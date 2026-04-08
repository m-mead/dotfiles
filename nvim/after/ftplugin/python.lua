vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local formatters = {
  { executable = "ruff",  command = "ruff format --stdin-filename % -" },
  { executable = "black", command = "black -q -" },
}

for _, formatter in ipairs(formatters) do
  if vim.fn.executable(formatter.executable) == 1 then
    vim.bo.formatprg = formatter.command
    vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "|setlocal formatprg<"
    return
  end
end
