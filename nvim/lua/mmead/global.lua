-- Use space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Use `jk` as a more ergonomic escape.
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', 'jk', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Globals
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["c"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["lua"] = true,
  ["python"] = true,
  ["rust"] = true,
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
vim.o.ttimeoutlen = 100
vim.o.signcolumn = 'yes'
vim.o.mouse = 'a'
vim.o.scrolloff = 8
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.pumheight = 8

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

-- Edit this file with a keystroke.
vim.api.nvim_set_keymap('n', '<leader>ve', ':edit ~/.config/nvim/init.lua<cr>', { noremap = true, silent = true })

-- Keybindings for moving around tabs.
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', { noremap = true, silent = true })

-- Keybindings for moving around buffers.
vim.api.nvim_set_keymap('n', '<leader>[b', ':bprev<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>]b', ':bnext<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-h>', ':bprev<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<cr>', { noremap = true, silent = true })

-- Keybindings for moving around windows.
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { noremap = true, silent = true })

-- Insert brace like characters when in insert mode.
vim.api.nvim_set_keymap('i', '$1', '()<esc>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '$2', '[]<esc>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '$3', '{}<esc>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '$4', '{<esc>o}<esc>O', { noremap = true, silent = true })

-- Insert brace like characters when in visual mode.
vim.api.nvim_set_keymap('v', '$1', '<esc>`>a)<esc>`<i(<esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '$2', '<esc>`>a]<esc>`<i[<esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '$3', '<esc>`>a}<esc>`<i{<esc>', { noremap = true, silent = true })

-- Insert blank characters without leaving insert mode.
vim.api.nvim_set_keymap('n', 'zj', 'o<esc>^Dk', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zk', 'O<esc>^Dj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zh', 'i<space><esc>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'zl', 'a<space><esc>h', { noremap = true, silent = true })

-- Indent selection without leaving visual mode.
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

