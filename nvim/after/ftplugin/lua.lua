vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

if vim.fn.executable("stylua") == 1 then
  vim.bo.formatprg = "stylua --search-parent-directories --stdin-filepath % -"
end
