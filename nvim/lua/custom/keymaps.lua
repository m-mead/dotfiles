-- Keybindings for moving around tabs.
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<cr>', { noremap = true, silent = true, desc = 'tab open' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<cr>', { noremap = true, silent = true, desc = 'tab next' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprev<cr>', { noremap = true, silent = true, desc = 'tab previous' })

-- Keybindings for moving around buffers.
vim.keymap.set('n', '<S-h>', '<cmd>bprev<cr>', { noremap = true, silent = true, desc = 'buffer previous' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { noremap = true, silent = true, desc = 'buffer next' })

-- Insert blank characters without leaving insert mode.
vim.keymap.set('n', 'zj', 'o<esc>^Dk', { noremap = true, silent = true, desc = 'insert blank link below' })
vim.keymap.set('n', 'zk', 'O<esc>^Dj', { noremap = true, silent = true, desc = 'insert blank line above' })
vim.keymap.set('n', 'zh', 'i<space><esc>l', { noremap = true, silent = true, desc = 'insert blank character right' })
vim.keymap.set('n', 'zl', 'a<space><esc>h', { noremap = true, silent = true, desc = 'insert blank character left' })

-- Indent selection without leaving visual mode.
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'shift selection left and hold on' })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'shift select right and hold on' })

-- Easier terminal exit.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Jump between quickfix list items.
vim.keymap.set('n', '<M-j>', '<cmd>cnext<cr>', { desc = 'next quickfix list item' })
vim.keymap.set('n', '<M-k>', '<cmd>cprevious<cr>', { desc = 'previous quickfix list item' })

-- Diagnostic keymappings.
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Yanking.
vim.keymap.set('v', '<leader>ys', '"*y', { noremap = true, silent = true, desc = 'yank selection to system clipboard' })

-- File explorer.
vim.keymap.set('n', '<leader>e', '<cmd>Ex<cr>', { noremap = true, silent = true, desc = 'open netrw' })
