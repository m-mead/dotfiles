-- This plugin implements a basic custom statusline.
-- It shows the normal nvim info and optionally shows diagnostics info and git info.
--
-- Requirements
--  - gitsigns
--
-- Reference guide: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
local M = {}

function M.mode()
  local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    [""] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    [""] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
  }
  return string.format(" %s ", modes[vim.api.nvim_get_mode().mode])
end

function M.filename()
  return vim.api.nvim_buf_get_name(0):gsub(vim.fn.getcwd() .. "/", "")
end

function M.diagnostics()
  local levels = {
    error = vim.diagnostic.severity.ERROR,
    warn = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hint = vim.diagnostic.severity.HINT,
  }

  local diagnostics = {}
  for k, level in pairs(levels) do
    diagnostics[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local error_count = ""
  local warn_count = ""
  local hint_count = ""
  local info_count = ""

  local has_diagnostics = false

  if diagnostics.error ~= 0 then
    error_count = "%#DiagnosticError#" .. string.format("%s ", diagnostics.error)
    has_diagnostics = true
  end

  if diagnostics.warn ~= 0 then
    warn_count = "%#DiagnosticWarn#" .. string.format("%s", diagnostics.warning)
    has_diagnostics = true
  end

  if diagnostics.hint ~= 0 then
    hint_count = "%#DiagnosticHint#" .. string.format("%s ", diagnostics.hint)
    has_diagnostics = true
  end

  if diagnostics.info ~= 0 then
    info_count = " %#DiagnosticInfo#" .. string.format("%s", levels.info)
    has_diagnostics = true
  end

  if not has_diagnostics then
    return ""
  end

  return table.concat({
    " 💡 ",
    error_count,
    warn_count,
    hint_count,
    info_count,
    "%#Normal# "
  })
end

function M.filetype()
  return string.format(" %s ", vim.bo.filetype)
end

function M.line()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

function M.git()
  local ok, _ = pcall(require, 'gitsigns')
  if not ok then
    return ""
  end

  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end

  local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
  local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
  local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""

  if git_info.added == 0 then
    added = ""
  end

  if git_info.changed == 0 then
    changed = ""
  end

  if git_info.removed == 0 then
    removed = ""
  end

  return table.concat {
    " ",
    added,
    changed,
    removed,
    " ",
    "%#GitSignsAdd#🌳 ",
    git_info.head,
    " %#Normal#",
  }
end

function M.statusline()
  return table.concat {
    "%#Statusline#",
    M.mode(),
    "%#Normal#",
    M.filename(),
    "%#Normal#",
    M.diagnostics(),
    M.git(),
    "%=%#StatusLineExtra#",
    M.filetype(),
    M.line(),
  }
end

function StatusLine()
  return M.statusline()
end

vim.o.statusline = "%!v:lua.StatusLine()"
