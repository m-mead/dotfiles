-- Workaround for mini.pick setting filetype to 'c' when opening cpp files.
if vim.bo.filetype ~= "c" then
  return
end

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

if vim.fn.executable("clang-format") == 1 then
  vim.bo.formatprg = "clang-format --assume-filename=%"
end
