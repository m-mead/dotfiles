--- *chickadee* Install Treesitter parsers
---
--- # Features:
--- - Install Treesitter parsers from source.
--- - Version specification via `version` option.
--- - Progress reporting with `nvim_echo(..., { kind = "progress" })`.
---
--- # Setup
--- Setup the module with `require('chickadee').setup(config)`.
--- See |chickadee.Spec| for configuration settings.

---@class chickadee.Spec
---@field src string
---@field ft string
---@field version? string

---@class chickadee.Grammar
---@field src string
---@field ft string
---@field version? string
---@field lib string
---@field cachedir string
---@field parserdir string
---@field queriesdir string
---@field sync fun(self: chickadee.Grammar, done?: fun(err?: string))
---@field is_installed fun(self: chickadee.Grammar): boolean

local Chickadee = {}
local Grammar = {}
Grammar.__index = Grammar

local uv = vim.uv or vim.loop

---@param msg string
---@param level? integer
local function notify(msg, level)
  vim.schedule(function()
    vim.notify("chickadee: " .. msg, level or vim.log.levels.INFO)
  end)
end

---@class chickadee.Progress
---@field id integer|string
---@field title string
---@field text string
---@field status '"running"'|'"success"'|'"error"'
---@field percent integer

---@param p chickadee.Progress
---@return integer|string
local function progress_update(p)
  return vim.api.nvim_echo({ { p.text } }, false, {
    id = p.id,
    kind = "progress",
    title = p.title,
    status = p.status,
    percent = p.percent,
    source = "chickadee",
  })
end

---@param start_pct integer
---@param end_pct integer
---@param current integer
---@param total integer
---@return integer
local function phase_percent(start_pct, end_pct, current, total)
  if total <= 0 then
    return end_pct
  end
  local span = end_pct - start_pct
  return start_pct + math.floor((current / total) * span)
end

---@param src string
---@param dst string
local function copyfile(src, dst)
  local ok, err = uv.fs_copyfile(src, dst)
  if not ok then
    error(err or ("copy failed: " .. src .. " -> " .. dst))
  end
end

---@param spec chickadee.Spec
---@return chickadee.Grammar
function Grammar.new(spec)
  if type(spec) ~= "table" then
    error("invalid spec: expected table")
  end
  if not spec.src or spec.src == "" then
    error("invalid spec: missing src")
  end
  if not spec.ft or spec.ft == "" then
    error("invalid spec: missing ft")
  end

  local data = vim.fn.stdpath("data")
  local cache = vim.fn.stdpath("cache")

  return setmetatable({
    src = spec.src,
    ft = spec.ft,
    version = spec.version,
    lib = spec.ft .. ".so",
    cachedir = cache .. "/chickadee/" .. spec.ft,
    parserdir = data .. "/site/parser",
    queriesdir = data .. "/site/queries/" .. spec.ft,
  }, Grammar)
end

function Grammar:parser_path()
  return self.parserdir .. "/" .. self.ft .. ".so"
end

function Grammar:library_path()
  return self.cachedir .. "/" .. self.lib
end

function Grammar:scanner_path()
  return self.cachedir .. "/src/scanner.c"
end

function Grammar:query_glob()
  return self.cachedir .. "/queries/*.scm"
end

function Grammar:has_scanner()
  return vim.fn.filereadable(self:scanner_path()) == 1
end

function Grammar:is_cloned()
  return vim.fn.isdirectory(self.cachedir) == 1
end

function Grammar:has_parser()
  return vim.fn.filereadable(self:parser_path()) == 1
end

function Grammar:has_queries()
  return vim.fn.isdirectory(self.queriesdir) == 1
end

function Grammar:is_installed()
  return self:is_cloned() and self:has_parser() and self:has_queries()
end

function Grammar:ensure_dirs()
  vim.fn.mkdir(vim.fn.fnamemodify(self.cachedir, ":h"), "p")
  vim.fn.mkdir(self.parserdir, "p")
  vim.fn.mkdir(self.queriesdir, "p")
end

---@return string[]
function Grammar:build_cmd()
  local uname = uv.os_uname()
  local sysname = uname.sysname
  local arch = uname.machine

  local cmd = {
    "cc",
    "-fPIC",
    "-I./src",
    "src/parser.c",
  }

  if self:has_scanner() then
    table.insert(cmd, "src/scanner.c")
  end

  if sysname == "Darwin" then
    table.insert(cmd, 2, "-dynamiclib")
    table.insert(cmd, "-o")
    table.insert(cmd, self.lib)
    table.insert(cmd, "-arch")
    table.insert(cmd, arch)
    return cmd
  end

  if sysname == "Linux" then
    table.insert(cmd, 2, "-shared")
    table.insert(cmd, "-o")
    table.insert(cmd, self.lib)
    return cmd
  end

  error("unsupported platform")
end

---@return integer
function Grammar:query_count()
  local files = vim.fn.glob(self:query_glob(), false, true)
  return #files
end

---@param update fun(text: string, percent: integer, status?: '"running"'|'"success"'|'"error"')
function Grammar:install(update)
  update("Installing parser", 88, "running")
  copyfile(self:library_path(), self:parser_path())

  local query_files = vim.fn.glob(self:query_glob(), false, true)
  local total = #query_files

  if total == 0 then
    update("Installed", 100, "success")
    return
  end

  for i, file in ipairs(query_files) do
    local name = vim.fn.fnamemodify(file, ":t")
    copyfile(file, self.queriesdir .. "/" .. name)
    update(
      ("Installing queries (%d/%d)"):format(i, total),
      phase_percent(90, 100, i, total),
      "running"
    )
  end
end

---@param line string
---@return integer?, string?
function Grammar:parse_git_progress(line)
  local receiving = line:match("Receiving objects:%s+(%d+)%%")
  if receiving then
    local pct = tonumber(receiving)
    if pct then
      return phase_percent(5, 40, pct, 100), ("Cloning (%d%% objects)"):format(pct)
    end
  end

  local resolving = line:match("Resolving deltas:%s+(%d+)%%")
  if resolving then
    local pct = tonumber(resolving)
    if pct then
      return phase_percent(40, 55, pct, 100), ("Resolving deltas (%d%%)"):format(pct)
    end
  end

  local compressing = line:match("Compressing objects:%s+(%d+)%%")
  if compressing then
    local pct = tonumber(compressing)
    if pct then
      return phase_percent(20, 35, pct, 100), ("Compressing objects (%d%%)"):format(pct)
    end
  end

  if line ~= "" then
    return nil, vim.trim(line)
  end
end

---@param cmd string[]
---@param opts? table
---@param cb fun(result?: vim.SystemCompleted, err?: string)
---@param on_stderr_line? fun(line: string)
local function run(cmd, opts, cb, on_stderr_line)
  opts = opts or {}

  if on_stderr_line then
    local stderr_chunks = {}
    local original_stderr = opts.stderr

    opts.stderr = function(_, data)
      if original_stderr then
        original_stderr(_, data)
      end

      if not data or data == "" then
        return
      end

      table.insert(stderr_chunks, data)
      local joined = table.concat(stderr_chunks)
      local lines = vim.split(joined, "\n", { plain = true })

      stderr_chunks = { lines[#lines] or "" }
      for i = 1, #lines - 1 do
        on_stderr_line(lines[i])
      end
    end
  end

  local ok, obj = pcall(vim.system, cmd, opts, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        cb(nil, result.stderr ~= "" and result.stderr or table.concat(cmd, " "))
      else
        cb(result, nil)
      end
    end)
  end)

  if not ok then
    vim.schedule(function()
      cb(nil, "failed to start command: " .. table.concat(cmd, " "))
    end)
    return
  end

  return obj
end

---@param done? fun(err?: string)
function Grammar:sync(done)
  done = done or function() end

  local progress = {
    id = "chickadee." .. self.ft,
    title = self.ft,
    text = "Queued",
    status = "running",
    percent = 0,
  }

  ---@param text string
  ---@param percent integer
  ---@param status? '"running"'|'"success"'|'"error"'
  local function update(text, percent, status)
    progress.text = text
    progress.percent = percent
    progress.status = status or progress.status

    vim.schedule(function()
      progress.id = progress_update(progress)
    end)
  end

  local function fail(err)
    update(err or ("failed for " .. self.ft), 100, "error")
    done(err or ("failed for " .. self.ft))
  end

  if self:is_installed() then
    update("Already installed", 100, "success")
    done()
    return
  end

  self:ensure_dirs()

  local function build()
    local build_start = self:has_scanner() and 58 or 62
    update("Building parser", build_start, "running")

    run(self:build_cmd(), { cwd = self.cachedir }, function(_, err)
      if err then
        fail(err)
        return
      end

      update("Build complete", 87, "running")

      local ok, install_err = pcall(function()
        self:install(update)
      end)

      if not ok then
        fail(install_err)
        return
      end

      update("Installed", 100, "success")
      done()
    end)
  end

  if self:is_cloned() then
    update("Using cached clone", 20, "running")
    build()
    return
  end

  update("Starting clone", 5, "running")

  local cmd
  if self.version then
    cmd = { "git", "clone", "--progress", "--depth", "1", "--revision", self.version, self.src, self.cachedir }
  else
    cmd = { "git", "clone", "--progress", "--depth", "1", self.src, self.cachedir }
  end

  run(
    cmd,
    { text = true },
    function(_, err)
      if err then
        fail(err)
        return
      end

      update("Clone complete", 55, "running")
      build()
    end,
    function(line)
      local pct, text = self:parse_git_progress(line)
      if pct and text then
        update(text, pct, "running")
      end
    end
  )
end

---@param grammars chickadee.Grammar[]
---@param i? integer
---@param failed? string[]
local function sync_queue(grammars, i, failed)
  i = i or 1
  failed = failed or {}

  local overall = {
    id = "chickadee.queue",
    title = "Treesitter grammars",
    text = "",
    status = "running",
    percent = 0,
  }

  local function update_overall(text, percent, status)
    overall.text = text
    overall.percent = percent
    overall.status = status or overall.status

    vim.schedule(function()
      overall.id = progress_update(overall)
    end)
  end

  if i > #grammars then
    if #failed == 0 then
      update_overall("All grammars installed", 100, "success")
    else
      update_overall(
        ("Finished with %d failure(s): %s"):format(#failed, table.concat(failed, ", ")),
        100,
        "error"
      )
      notify(
        ("Some grammars failed: %s"):format(table.concat(failed, ", ")),
        vim.log.levels.ERROR
      )
    end
    return
  end

  local grammar = grammars[i]
  local percent = math.floor(((i - 1) / #grammars) * 100)

  update_overall(("Processing (%d/%d) %s"):format(i, #grammars, grammar.ft), percent, "running")

  grammar:sync(function(err)
    if err then
      table.insert(failed, grammar.ft)
    end
    sync_queue(grammars, i + 1, failed)
  end)
end

---@param config? chickadee.Spec[]
function Chickadee.setup(config)
  if vim.fn.has("nvim-0.12") == 0 then
    vim.notify("chickadee requires neovim >= 0.12", vim.log.levels.ERROR)
    return
  end

  local missing = {}

  for _, spec in ipairs(config or {}) do
    local grammar = Grammar.new(spec)
    if not grammar:is_installed() then
      table.insert(missing, grammar)
    end
  end

  if #missing == 0 then
    return
  end

  local max_ft = 0
  local max_src = 0

  for _, grammar in ipairs(missing) do
    max_ft = math.max(max_ft, #grammar.ft)
    max_src = math.max(max_src, #grammar.src)
  end

  local lines = { "These grammars will be installed:", "" }

  for _, grammar in ipairs(missing) do
    lines[#lines + 1] = ("%-" .. max_ft .. "s  from  %-" .. max_src .. "s"):format(
      grammar.ft,
      grammar.src
    )
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "Proceed?"

  local answer = vim.fn.confirm(table.concat(lines, "\n"), "&Yes\n&No", 1)

  if answer == 1 then
    sync_queue(missing, 1)
  end
end

return Chickadee
