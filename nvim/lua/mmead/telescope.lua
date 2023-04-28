require('telescope').setup({})

local telescope_builtin = require('telescope.builtin')
local telescope_themes = require('telescope.themes')

vim.keymap.set('n', '<leader>!', telescope_builtin.resume, { desc = '[!] Resume previous search' })

-- Buffers
vim.keymap.set('n', '<leader><space>', function()
  telescope_builtin.buffers(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[ ] Find buffer' })

-- Old files
vim.keymap.set('n', '<leader>?', function()
  telescope_builtin.oldfiles(telescope_themes.get_dropdown({ previewer = false, only_cwd = true, cwd = vim.fn.getcwd() }))
end, { desc = '[?] Find recently opened files' })

-- All files
vim.keymap.set('n', '<leader>sa', function()
  telescope_builtin.find_files(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [A]ll files' })

-- Git files
vim.keymap.set('n', '<leader>sf', function()
  telescope_builtin.git_files(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [F]iles' })

-- Commands
vim.keymap.set('n', '<leader>sc', function()
  telescope_builtin.command_history(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [C]ommand history' })

-- Grep
vim.keymap.set('n', '<leader>sg', function()
  telescope_builtin.live_grep({ previewer = false })
end, { desc = '[S]earch using [G]rep' })

vim.keymap.set('n', '<leader>sw', function()
  telescope_builtin.grep_string({ previewer = false })
end, { desc = '[S]earch [W]ord' })

vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sj', telescope_builtin.jumplist, { desc = '[S]earch [J]ump list' })

-- Config files
vim.keymap.set('n', '<leader>ve', function()
  telescope_builtin.find_files(telescope_themes.get_dropdown({ previewer = false, cwd = vim.fn.stdpath('config') }))
end, { desc = '[S]earch [F]iles' })
