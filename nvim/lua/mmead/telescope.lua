require('telescope').setup({})

local telescope_builtin = require('telescope.builtin')
local telescope_themes = require('telescope.themes')

vim.keymap.set('n', 'sr', telescope_builtin.resume, { desc = 'search resume' })

-- Buffers
vim.keymap.set('n', '<leader><space>', function()
  telescope_builtin.buffers(telescope_themes.get_dropdown({ previewer = false, layout_config = { width = 0.8 } }))
end, { desc = 'find buffer' })

-- Old files
vim.keymap.set('n', '<leader>?', function()
  telescope_builtin.oldfiles(telescope_themes.get_dropdown({ previewer = false, only_cwd = true, cwd = vim.fn.getcwd(),
    layout_config = { width = 0.8 } }))
end, { desc = 'recent files' })

-- All files
vim.keymap.set('n', '<leader>sa', function()
  telescope_builtin.find_files(telescope_themes.get_dropdown({ previewer = false, layout_config = { width = 0.8 } }))
end, { desc = 'search all files' })

-- Git files
vim.keymap.set('n', '<leader>sf', function()
  telescope_builtin.git_files(telescope_themes.get_dropdown({ previewer = false, layout_config = { width = 0.8 } }))
end, { desc = 'search git files' })

-- Commands
vim.keymap.set('n', '<leader>sc', function()
  telescope_builtin.command_history(telescope_themes.get_dropdown({ previewer = false, layout_config = { width = 0.8 } }))
end, { desc = 'search command history' })

-- Commands
vim.keymap.set('n', '<leader>sk', function()
  telescope_builtin.keymaps(telescope_themes.get_dropdown({ previewer = false, layout_config = { width = 0.8 } }))
end, { desc = 'search keymaps' })

-- Grep
vim.keymap.set('n', '<leader>sg', function()
  telescope_builtin.live_grep()
end, { desc = 'search live grep' })

vim.keymap.set('n', '<leader>sw', function()
  telescope_builtin.grep_string()
end, { desc = 'search word under cursor' })

vim.keymap.set('n', '<leader>sh', function()
  telescope_builtin.help_tags()
end, { desc = 'search help tags' })

vim.keymap.set('n', '<leader>sj', function()
  telescope_builtin.jumplist()
end, { desc = 'search ump list' })

-- Config files
vim.keymap.set('n', '<leader>s0', function()
  telescope_builtin.find_files(telescope_themes.get_dropdown({ previewer = false, cwd = vim.fn.stdpath('config'),
    layout_config = { width = 0.8 } }))
end, { desc = 'search dotfiles' })
