--- treesitter
--- Install Treesitter parsers

---@class treesitter.Spec
---@field src string URL
---@field lang string Parser language name, e.g. "javascript", "tsx"
---@field ft string|string[] Filetype(s) mapped to this language
---@field version? string Version (branch, tag, or commit)
---@field root? string Subdirectory where the parser lives

---@class treesitter.Grammar
---@field src string URL
---@field lang string Parser language name
---@field ft string[] Filetypes mapped to this language
---@field version? string Version (branch, tag, or commit)
---@field lib string Shared library filename
---@field cachedir string Directory where grammar is cloned
---@field rootdir string Directory where the parser lives
---@field parserdir string Directory where parser is installed
---@field queriesdir string Directory where queries are installed
---@field sync fun(self: treesitter.Grammar, complete?: fun(err?: string)) Sync grammar from `src`
---@field has_parser fun(self: treesitter.Grammar): boolean Check grammar has a parser
---@field is_installed fun(self: treesitter.Grammar): boolean Check grammar is installed
---@field register_filetypes fun(self: treesitter.Grammar)
---@field parser_path fun(self: treesitter.Grammar): string

local M = {}
local Grammar = {}
Grammar.__index = Grammar

local uv = vim.uv or vim.loop

---@param id string Message ID
---@param text string Text to display
---@param status '"running"'|'"success"'|'"failed"'
---@param percent integer Number between 0 and 100
---@return string
local function progress_update(id, text, status, percent)
  local chunks = { { text } }
  local history = false
  local opts = {
    id = id,
    kind = "progress",
    title = "treesitter",
    status = status,
    percent = percent,
    source = "treesitter",
  }

  local message_id = vim.api.nvim_echo(chunks, history, opts)
  if type(message_id) ~= "string" then
    error("invalid message_id: expected string")
  end

  return message_id
end

---@param src string
---@param dst string
local function copyfile(src, dst)
  local ok, err = uv.fs_copyfile(src, dst)
  if not ok then
    error(err or ("copy failed: " .. src .. " -> " .. dst))
  end
end

---@param cmd string[]
---@param opts vim.SystemOpts
---@param complete fun(err?: string)
---@return vim.SystemObj?
local function run(cmd, opts, complete)
  local ok, obj = pcall(vim.system, cmd, opts, function(result)
    vim.schedule(function()
      if result.code == 0 then
        complete(nil)
      else
        local err = result.stderr
        if not err or err == "" then
          err = result.stdout
        end
        if not err or err == "" then
          err = table.concat(cmd, " ")
        end
        complete(err)
      end
    end)
  end)

  if not ok then
    vim.schedule(function()
      complete("command failed: " .. table.concat(cmd, " "))
    end)
    return
  end

  return obj
end

---@param x any
---@return string[]
local function normalize_fts(x)
  if type(x) == "string" then
    return { x }
  end

  if type(x) == "table" then
    local out = {}
    for _, v in ipairs(x) do
      if type(v) ~= "string" or v == "" then
        error("invalid ft entry: expected non-empty string")
      end
      table.insert(out, v)
    end

    if #out == 0 then
      error("invalid spec: missing ft")
    end

    return out
  end

  error("invalid spec.ft: expected string or string[]")
end

---@param grammars treesitter.Grammar[]
local function load_grammars(grammars)
  vim.schedule(function()
    for _, grammar in ipairs(grammars) do
      if grammar:has_parser() then
        pcall(vim.treesitter.language.add, grammar.lang, { path = grammar:parser_path() })
      else
        pcall(vim.treesitter.language.add, grammar.lang)
      end
    end
  end)
end

---@param complete fun(err?: string)
---@return nil
function Grammar:build(complete)
  local opts = { cwd = self.rootdir }

  local complete_wrapper = function(err)
    if err then
      complete("build failed: " .. err)
      return
    end

    local ok, install_err = pcall(function()
      self:install()
    end)

    if not ok then
      complete("install failed: " .. install_err)
      return
    end

    complete(nil)
  end

  run(self:build_cmd(), opts, complete_wrapper)
end

---@param spec treesitter.Spec
---@return treesitter.Grammar
function Grammar.new(spec)
  if type(spec) ~= "table" then
    error("invalid spec: expected table")
  end

  if not spec.src or spec.src == "" then
    error("invalid spec: missing src")
  end

  if not spec.lang or spec.lang == "" then
    error("invalid spec: missing lang")
  end

  local fts = normalize_fts(spec.ft)

  local data = vim.fn.stdpath("data")
  local cache = vim.fn.stdpath("cache")
  local cachedir = cache .. "/treesitter-grammars/" .. spec.lang

  local rootdir = cachedir
  if spec.root ~= nil then
    rootdir = ("%s/%s"):format(cachedir, spec.root)
  end

  return setmetatable({
    src = spec.src,
    lang = spec.lang,
    ft = fts,
    version = spec.version,
    lib = spec.lang .. ".so",
    cachedir = cachedir,
    rootdir = rootdir,
    parserdir = data .. "/site/parser",
    queriesdir = data .. "/site/queries/" .. spec.lang,
  }, Grammar)
end

---@return string
function Grammar:parser_path()
  return self.parserdir .. "/" .. self.lang .. ".so"
end

---@return string
function Grammar:library_path()
  return self.rootdir .. "/" .. self.lib
end

---@return string
function Grammar:scanner_path()
  return self.rootdir .. "/src/scanner.c"
end

---@return string
function Grammar:query_glob()
  return self.rootdir .. "/queries/*.scm"
end

---@return string[]
function Grammar:query_files()
  local seen = {}
  local files = {}
  local roots = { self.rootdir }

  if self.cachedir ~= self.rootdir then
    table.insert(roots, self.cachedir)
  end

  for _, root in ipairs(roots) do
    local matches = vim.fn.glob(root .. "/queries/*.scm", false, true)
    for _, file in ipairs(matches) do
      if not seen[file] then
        seen[file] = true
        table.insert(files, file)
      end
    end
  end

  return files
end

---@return boolean
function Grammar:has_scanner()
  return vim.fn.filereadable(self:scanner_path()) == 1
end

---@return boolean
function Grammar:is_cloned()
  return vim.fn.isdirectory(self.cachedir) == 1
end

---@return boolean
function Grammar:has_parser()
  return vim.fn.filereadable(self:parser_path()) == 1
end

---@return boolean
function Grammar:has_queries()
  local query_files = vim.fn.glob(self.queriesdir .. "/*.scm", false, true)
  return #query_files > 0
end

---@return boolean
function Grammar:has_highlights()
  return vim.fn.filereadable(self.queriesdir .. "/highlights.scm") == 1
end

---@return boolean
function Grammar:is_installed()
  return self:is_cloned() and self:has_parser() and self:has_queries()
end

---@return nil
function Grammar:ensure_dirs()
  vim.fn.mkdir(vim.fn.fnamemodify(self.cachedir, ":h"), "p")
  vim.fn.mkdir(self.parserdir, "p")
  vim.fn.mkdir(self.queriesdir, "p")
end

---@return nil
function Grammar:register_filetypes()
  for _, ft in ipairs(self.ft) do
    if ft ~= self.lang then
      vim.treesitter.language.register(self.lang, ft)
    end
  end
end

---@return string[]
function Grammar:build_cmd()
  local uname = uv.os_uname()
  local sysname = uname.sysname

  if sysname == "Darwin" then
    if vim.fn.executable("clang") == 0 then
      error("clang not found")
    end

    local cmd = {
      "clang",
      "-fPIC",
      "-I./src",
      "src/parser.c",
    }

    if self:has_scanner() then
      table.insert(cmd, "src/scanner.c")
    end

    vim.list_extend(cmd, { "-dynamiclib", "-O3", "-o", self.lib, "-arch", uname.machine })
    return cmd
  end

  if sysname == "Linux" then
    if vim.fn.executable("gcc") == 0 then
      error("gcc not found")
    end

    local cmd = {
      "gcc",
      "-fPIC",
      "-I./src",
      "src/parser.c",
    }

    if self:has_scanner() then
      table.insert(cmd, "src/scanner.c")
    end

    vim.list_extend(cmd, { "-shared", "-O3", "-o", self.lib })
    return cmd
  end

  error("unsupported platform")
end

---@return string[]
function Grammar:clone_cmd()
  if self.version == nil then
    return { "git", "clone", "--depth", "1", self.src, self.cachedir }
  end
  return { "git", "clone", "--depth", "1", "--revision", self.version, self.src, self.cachedir }
end

---@return nil
function Grammar:install()
  copyfile(self:library_path(), self:parser_path())

  local query_files = self:query_files()
  for _, file in ipairs(query_files) do
    local name = vim.fn.fnamemodify(file, ":t")
    copyfile(file, self.queriesdir .. "/" .. name)
  end
end

---@param complete fun(err?: string)
---@return nil
function Grammar:sync(complete)
  if self:is_installed() then
    complete()
    return
  end

  self:ensure_dirs()

  if self:is_cloned() then
    self:build(complete)
    return
  end

  run(self:clone_cmd(), { text = true }, function(err)
    if err then
      complete("clone failed: " .. err)
      return
    end
    self:build(complete)
  end)
end

---@param grammars treesitter.Grammar[]
---@param i? integer
---@param failed? string[]
---@param complete? fun()
---@return nil
local function sync_queue(grammars, i, failed, complete)
  i = i or 1
  failed = failed or {}

  local progress_id = "treesitter.sync_queue"

  if i > #grammars then
    if #failed == 0 then
      vim.schedule(function()
        progress_id = progress_update(progress_id, "All grammars installed", "success", 100)
      end)
    else
      vim.schedule(function()
        local text = ("Finished with %d failure(s): %s"):format(#failed, table.concat(failed, ", "))
        progress_id = progress_update(progress_id, text, "failed", 100)
      end)
    end
    if complete then
      complete()
    end
    return
  end

  local grammar = grammars[i]

  vim.schedule(function()
    local text = ("Installing grammar %d/%d %s from %s"):format(i - 1, #grammars, grammar.lang, grammar.src)
    local percent = math.floor(((i - 1) / #grammars) * 100)
    progress_id = progress_update(progress_id, text, "running", percent)
  end)

  grammar:sync(function(err)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      table.insert(failed, grammar.lang)
    end
    sync_queue(grammars, i + 1, failed, complete)
  end)
end

---@param config? treesitter.Spec[]
---@return nil
function M.setup(config)
  local missing = {}
  local grammars = {}

  for _, spec in ipairs(config or {}) do
    local grammar = Grammar.new(spec)
    grammar:register_filetypes()
    table.insert(grammars, grammar)

    if not grammar:is_installed() then
      table.insert(missing, grammar)
    end
  end

  if #missing == 0 then
    load_grammars(grammars)
    return
  end

  local max_lang = 0
  local max_src = 0

  for _, grammar in ipairs(missing) do
    max_lang = math.max(max_lang, #grammar.lang)
    max_src = math.max(max_src, #grammar.src)
  end

  local lines = { "These grammars will be installed:", "" }
  for _, grammar in ipairs(missing) do
    lines[#lines + 1] = ("%-" .. max_lang .. "s from %-" .. max_src .. "s"):format(grammar.lang, grammar.src)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "Proceed?"

  local answer = vim.fn.confirm(table.concat(lines, "\n"), "&Yes\n&No", 1)
  if answer == 1 then
    sync_queue(missing, 1, nil, function()
      load_grammars(grammars)
    end)
    return
  end

  load_grammars(grammars)
end

return M
