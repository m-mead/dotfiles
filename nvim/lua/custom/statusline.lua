-- This plugin implements a basic custom statusline.
-- It shows the normal nvim info and optionally shows diagnostics info and git info.
--
-- Requirements
--  - mini.diff
--
-- Reference guide: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
local M = {}

-- Minimal set of icons from nvmi-web-devicons.
-- Reference: https://github.com/nvim-tree/nvim-web-devicons/blob/master/lua/nvim-web-devicons/default/icons_by_file_extension.lua
local filetype_icons = {
  bash            = "",
  bat             = "",
  c               = "",
  cmake           = "",
  conf            = "󰈙",
  cpp             = "",
  css             = "",
  csv             = "",
  cuda            = "",
  dockerfile      = "󰡨",
  go              = "",
  graphql         = "",
  hh              = "",
  html            = "",
  javascript      = "",
  javascriptreact = "",
  json            = "",
  json5           = "",
  jsonc           = "",
  lua             = "",
  make            = "",
  markdown        = "",
  md              = "",
  objc            = "",
  odin            = "󰟢",
  php             = "",
  python          = "",
  scala           = "",
  sh              = "",
  svelte          = "",
  swift           = "",
  template        = "",
  terraform       = "",
  text            = "󰈙",
  toml            = "",
  typescript      = "",
  typescriptreact = "",
  vim             = "",
  xml             = "󰗀",
  yaml            = "",
  zig             = "",
  zsh             = "",
}

local function get_highlight(options)
  for _, option in ipairs(options) do
    local value = vim.api.nvim_get_hl(0, { name = option, link = false })
    if value then
      return value
    end
  end
  return {}
end

function M.setup_highlights()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

  vim.api.nvim_set_hl(0, "StatusLine", {
    fg = normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = get_highlight({ "Comment" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineGitBranch", {
    fg = get_highlight({ "Directory" }).fg or normal.fg,
    bg = normal.bg,
    bold = true,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineGitAdd", {
    fg = get_highlight({ "Added", "DiffAdd", "String" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineGitChange", {
    fg = get_highlight({ "Changed", "DiffChange", "Special" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineGitDelete", {
    fg = get_highlight({ "Removed", "DiffDelete", "Error", }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineDiagError", {
    fg = get_highlight({ "DiagnosticError", "Error" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineDiagWarn", {
    fg = get_highlight({ "DiagnosticWarn", "WarningMsg" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineDiagInfo", {
    fg = get_highlight({ "DiagnosticInfo", "Identifier" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineDiagHint", {
    fg = get_highlight({ "DiagnosticHint", "MoreMsg" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineMode", {
    fg = get_highlight({ "Function" }).fg or normal.fg,
    bg = normal.bg,
    bold = true,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineFile", {
    fg = normal.fg,
    bg = normal.bg,
    reverse = false,
  })

  vim.api.nvim_set_hl(0, "StatusLineMeta", {
    fg = get_highlight({ "Comment" }).fg or normal.fg,
    bg = normal.bg,
    reverse = false,
  })
end

function M.mode()
  local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    ["\22"] = "VISUAL BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    ["\19"] = "SELECT BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
  }

  local mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[mode] or mode)
end

function M.filename()
  local name = vim.fn.expand("%:.")
  return name or "[No Name]"
end

function M.diagnostics()
  local levels = {
    error = vim.diagnostic.severity.ERROR,
    warn = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hint = vim.diagnostic.severity.HINT,
  }

  local diagnostics = {}
  for key, severity in pairs(levels) do
    diagnostics[key] = vim.tbl_count(vim.diagnostic.get(0, { severity = severity }))
  end

  local parts = {}

  if diagnostics.error > 0 then
    table.insert(parts, "%#StatusLineDiagError#" .. diagnostics.error .. " ")
  end
  if diagnostics.warn > 0 then
    table.insert(parts, "%#StatusLineDiagWarn#" .. diagnostics.warn .. " ")
  end
  if diagnostics.info > 0 then
    table.insert(parts, "%#StatusLineDiagInfo#" .. diagnostics.info .. " ")
  end
  if diagnostics.hint > 0 then
    table.insert(parts, "%#StatusLineDiagHint#" .. diagnostics.hint .. " ")
  end

  if #parts == 0 then
    return ""
  end

  return table.concat({
    " ",
    "%#StatusLine#💡 ",
    table.concat(parts),
    "%#StatusLine#",
  })
end

function M.filetype()
  local ft = vim.bo.filetype
  if ft == "" then
    return " text "
  end

  local icon = filetype_icons[ft] or ""
  return string.format(" %s %s ", icon, ft)
end

function M.lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

function M.git()
  local ok, _ = pcall(require, "mini.diff")
  if not ok then
    return ""
  end

  local git_info = vim.b.minidiff_summary
  if not git_info then
    return ""
  end

  local added = git_info.add or 0
  local changed = git_info.change or 0
  local removed = git_info.delete or 0
  local branch = vim.b.statusline_git_branch

  if not branch then
    local root = vim.fs.root(0, ".git")
    if root then
      local result = vim.system(
        { "git", "rev-parse", "--abbrev-ref", "HEAD" },
        { text = true, cwd = root }
      ):wait()
      if result.code == 0 and result.stdout then
        branch = result.stdout:gsub("%s+$", "")
        vim.b.statusline_git_branch = branch
      end
    end
  end

  local parts = { " " }

  if added > 0 then
    table.insert(parts, "%#StatusLineGitAdd#+" .. added .. " ")
  end
  if changed > 0 then
    table.insert(parts, "%#StatusLineGitChange#~" .. changed .. " ")
  end
  if removed > 0 then
    table.insert(parts, "%#StatusLineGitDelete#-" .. removed .. " ")
  end

  if branch and branch ~= "" then
    table.insert(parts, "%#StatusLineGitBranch#🌳 ")
    table.insert(parts, branch)
    table.insert(parts, " ")
  end
  table.insert(parts, "%#StatusLine#")

  return table.concat(parts)
end

function M.render()
  return table.concat({
    "%#StatusLineMode#",
    M.mode(),
    "%#StatusLineFile#",
    M.filename(),
    "%#StatusLine#",
    M.diagnostics(),
    M.git(),
    "%=%#StatusLineMeta#",
    M.filetype(),
    M.lineinfo(),
  })
end

return M
