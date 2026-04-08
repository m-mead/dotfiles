if vim.fn.executable("rustfmt") == 1 then
  vim.bo.formatprg = "rustfmt -q --emit=stdout"
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "|setlocal formatprg<"
end
