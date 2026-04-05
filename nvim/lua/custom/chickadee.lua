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
---@field src string URL
---@field ft string Filetype
---@field version? string Version (branch, tag, or commit)

---@class chickadee.Grammar
---@field src string URL
---@field ft string Filetype
---@field version? string Version (branch, tag, or commit)
---@field lib string Shared library filename
---@field cachedir string Directory where grammar is cloned
---@field parserdir string Directory where parser is installed
---@field queriesdir string Directory where grammars are installed
---@field sync fun(self: chickadee.Grammar, complete?: fun(err?: string)) Sync grammar from `src`
---@field is_installed fun(self: chickadee.Grammar): boolean Check grammar is installed

local Chickadee = {}
local Grammar = {}
Grammar.__index = Grammar

local uv = vim.uv or vim.loop

---@param id string Message ID
---@param text string Text to display
---@param status '"running"'|'"success"'|'"failed"' Update status
---@param percent integer Number between 0 and 100
---@return string
local function progress_update(id, text, status, percent)
  local chunks = { { text } }
  local history = false
  local opts = {
    id = id,
    kind = "progress",
    title = "Chickadee",
    status = status,
    percent = percent,
    source = "chickadee",
  }

  local message_id = vim.api.nvim_echo(chunks, history, opts)
  if type(message_id) ~= "string" then
    error("invalid message_id: expected string")
  end

  return message_id
end

---@param src string Source filepath
---@param dst string Output filepath
local function copyfile(src, dst)
  local ok, err = uv.fs_copyfile(src, dst)
  if not ok then
    error(err or ("copy failed: " .. src .. " -> " .. dst))
  end
end

---@param cmd string[] Command to run
---@param opts vim.SystemOpts Command options
---@param complete fun(err?: string) Called when the command completes
---@return vim.SystemObj?
local function run(cmd, opts, complete)
  local ok, obj = pcall(vim.system, cmd, opts, function(result)
    vim.schedule(function()
      if result.code == 0 then
        complete(nil)
      else
        complete(result.stderr ~= "" and result.stderr or table.concat(cmd, " "))
      end
    end)
  end)

  if not ok then
    vim.schedule(function() complete("command failed: " .. table.concat(cmd, " ")) end)
    return
  end

  return obj
end

---@param spec chickadee.Spec Config spec
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

---@return string
function Grammar:parser_path()
  return self.parserdir .. "/" .. self.ft .. ".so"
end

---@return string
function Grammar:library_path()
  return self.cachedir .. "/" .. self.lib
end

---@return string
function Grammar:scanner_path()
  return self.cachedir .. "/src/scanner.c"
end

---@return string
function Grammar:query_glob()
  return self.cachedir .. "/queries/*.scm"
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
  return vim.fn.isdirectory(self.queriesdir) == 1
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

---@return string[]
function Grammar:clone_cmd()
  if self.version then
    return { "git", "clone", "--progress", "--depth", "1", "--revision", self.version, self.src, self.cachedir }
  end
  return { "git", "clone", "--progress", "--depth", "1", self.src, self.cachedir }
end

---@return nil
function Grammar:install()
  copyfile(self:library_path(), self:parser_path())

  local query_files = vim.fn.glob(self:query_glob(), false, true)
  local total = #query_files

  if total == 0 then
    return
  end

  for _, file in ipairs(query_files) do
    local name = vim.fn.fnamemodify(file, ":t")
    copyfile(file, self.queriesdir .. "/" .. name)
  end
end

---@param complete fun(err?: string)
---@return nil
function Grammar:build(complete)
  local opts = { cwd = self.cachedir }

  local complete_wrapper = function(err)
    if err then
      complete(err)
      return
    end

    local ok, install_err = pcall(function() self:install() end)
    if not ok then
      complete(install_err)
      return
    end

    complete(nil)
  end

  run(self:build_cmd(), opts, complete_wrapper)
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

  local opts = { text = true }
  local complete_wrapper = function(err)
    if err then
      complete(err)
      return
    end
    self:build(complete)
  end

  run(self:clone_cmd(), opts, complete_wrapper)
end

---@param grammars chickadee.Grammar[]
---@param i? integer
---@param failed? string[]
---@return nil
local function sync_queue(grammars, i, failed)
  i = i or 1
  failed = failed or {}

  local progress_id = "chickadee.sync_queue"

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
    return
  end

  local grammar = grammars[i]

  vim.schedule(function()
    local text = ("Installing %s from %s"):format(grammar.ft, grammar.src)
    local percent = math.floor(((i - 1) / #grammars) * 100)
    progress_id = progress_update(progress_id, text, "running", percent)
  end)

  grammar:sync(function(err)
    if err then
      table.insert(failed, grammar.ft)
    end
    sync_queue(grammars, i + 1, failed)
  end)
end

---@param config? chickadee.Spec[]
---@return nil
function Chickadee.setup(config)
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
    lines[#lines + 1] = ("%-" .. max_ft .. "s from %-" .. max_src .. "s"):format(grammar.ft, grammar.src)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "Proceed?"

  local answer = vim.fn.confirm(table.concat(lines, "\n"), "&Yes\n&No", 1)
  if answer == 1 then
    sync_queue(missing, 1)
  end
end

return Chickadee
