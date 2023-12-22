vim.keymap.set('i', '<M-J>', 'copilot#Accept("<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
