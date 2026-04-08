if vim.fn.executable("zig") == 1 then
  vim.bo.formatprg = "zig fmt --stdin"
end
