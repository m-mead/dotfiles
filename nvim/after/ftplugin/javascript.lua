vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

if vim.fn.executable("prettier") == 1 then
  vim.bo.formatprg = "prettier --stdin-filepath % --config-precedence prefer-file"
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "|setlocal formatprg<"
  vim.bo.formatexpr = ""
end
