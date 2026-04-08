if vim.fn.executable("prettier") == 1 then
  vim.bo.formatprg = "prettier --stdin-filepath % --config-precedence prefer-file"
  vim.bo.formatexpr = ""
end
