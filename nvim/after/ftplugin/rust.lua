if vim.fn.executable("rustfmt") == 1 then
  vim.bo.formatprg = "rustfmt -q --emit=stdout"
end
