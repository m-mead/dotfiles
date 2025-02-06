vim.api.nvim_create_user_command('Black', function(_) vim.cmd('!black %') end,
  { nargs = 0 })
