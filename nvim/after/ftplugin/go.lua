vim.opt_local.expandtab = false

if vim.fn.executable("gofmt") == 1 then
  vim.bo.formatprg = "gofmt"
end
