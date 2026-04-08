if vim.fn.executable("zig") == 1 then
  vim.bo.formatprg = "zig fmt --stdin"
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "|setlocal formatprg<"
end
