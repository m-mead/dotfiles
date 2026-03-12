if vim.fn.executable("prettier") then
  vim.bo.formatprg = "prettier --stdin-filepath % --config-precedence prefer-file"
  vim.bo.formatexpr = ""
end
