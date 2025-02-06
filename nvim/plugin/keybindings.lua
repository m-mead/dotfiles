-- Keybindings for moving around tabs.
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', { noremap = true, silent = true, desc = 'tab open' })
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', { noremap = true, silent = true, desc = 'tab next' })
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', { noremap = true, silent = true, desc = 'tab previous' })

-- Keybindings for moving around buffers.
vim.api.nvim_set_keymap('n', '<S-h>', ':bprev<cr>', { noremap = true, silent = true, desc = 'buffer previous' })
vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<cr>', { noremap = true, silent = true, desc = 'buffer next' })

-- Insert blank characters without leaving insert mode.
vim.api.nvim_set_keymap('n', 'zj', 'o<esc>^Dk', { noremap = true, silent = true, desc = 'insert blank link below' })
vim.api.nvim_set_keymap('n', 'zk', 'O<esc>^Dj', { noremap = true, silent = true, desc = 'insert blank line above' })
vim.api.nvim_set_keymap('n', 'zh', 'i<space><esc>l',
  { noremap = true, silent = true, desc = 'insert blank character right' })
vim.api.nvim_set_keymap('n', 'zl', 'a<space><esc>h',
  { noremap = true, silent = true, desc = 'insert blank character left' })

-- Indent selection without leaving visual mode.
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true, desc = 'shift selection left and hold on' })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true, desc = 'shift select right and hold on' })

-- Easier terminal exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Jump between quickfix list items
vim.keymap.set('n', '<M-j>', '<cmd>cnext<cr>', { desc = 'next quickfix list item' })
vim.keymap.set('n', '<M-k>', '<cmd>cprevious<cr>', { desc = 'previous quickfix list item' })

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })
