vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

if vim.fn.executable("mmdc") == 1 then
  vim.opt_local.makeprg = [[mmdc -i "%" -o "%:r.svg"]]
end
