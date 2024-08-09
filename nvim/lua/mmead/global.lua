-- Use space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Copilot settings
-- These seem to need to be set before any mappings are created.
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set('i', '<M-J>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, silent = true, })
vim.api.nvim_set_keymap("i", "<M-N>", 'copilot#Previous()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-P>", 'copilot#Next()', { silent = true, expr = true })

vim.g.copilot_filetypes = {
  ["*"] = false,
  ["c"] = true,
  ["cpp"] = true,
  ["go"] = true,
  ["javascript"] = true,
  ["lua"] = true,
  ["python"] = true,
  ["rust"] = true,
  ["typescript"] = true,
}

-- Basic settings
vim.o.filetype = 'on'
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildmenu = true
vim.o.errorbells = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.tabstop = 4
vim.o.startofline = false
vim.o.backspace = 'indent,eol,start'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.wildignore = '.pyc,.swp,*/.git/*,*/.DS_Store,*/build/*,*/tmp/*,*/venv/*'
vim.o.wildmode = 'longest:full,full'
vim.o.swapfile = false
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 50
vim.o.signcolumn = 'yes'
vim.o.mouse = 'a'
vim.o.scrolloff = 8
vim.o.cursorline = true
-- vim.o.termguicolors = true
vim.o.pumheight = 8
vim.o.laststatus = 3
vim.o.spelllang = "en_us"
vim.o.spell = true

-- Stop inserting comments on new lines when previous line is commented.
-- This is the default vim behavior.
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end
})

-- Remember the last position when reopening a file.
vim.cmd([[
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

-- Keybindings for moving around tabs.
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', { noremap = true, silent = true, desc = 'tab open' })
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', { noremap = true, silent = true, desc = 'tab next' })
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', { noremap = true, silent = true, desc = 'tab previous' })

-- Keybindings for moving around buffers.
vim.api.nvim_set_keymap('n', '<S-h>', ':bprev<cr>', { noremap = true, silent = true, desc = 'buffer previous' })
vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<cr>', { noremap = true, silent = true, desc = 'buffer next' })

-- Keybindings for moving around windows.
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true, desc = 'window down' })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { noremap = true, silent = true, desc = 'window up' })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { noremap = true, silent = true, desc = 'window left' })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { noremap = true, silent = true, desc = 'window right' })

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

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Easier terminal exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
