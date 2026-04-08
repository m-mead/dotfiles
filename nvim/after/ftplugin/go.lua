vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

if vim.fn.executable("gofmt") == 1 then
  vim.bo.formatprg = "gofmt"
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "|setlocal formatprg<"
end
