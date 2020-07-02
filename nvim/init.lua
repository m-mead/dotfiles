-- -------------------------------------------------------------------------------------
-- Author: Michael Mead
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- Core
-- -------------------------------------------------------------------------------------

vim.cmd([[
set nocompatible

syntax enable
filetype on
filetype plugin on
set nowrap

set number
set wildmenu
set laststatus=2
set noerrorbells
set relativenumber

set hidden
set splitright
set splitbelow

set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set expandtab

set nostartofline
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
set nohlsearch
set wildignore+=.pyc,.swp,*/.git/*,*/.DS_Store,*/build/*,*/tmp/*,*/venv/*
set wildmode=longest:full,full

set ttyfast

set noswapfile
set autoread

set timeout
set timeoutlen=500
set ttimeoutlen=100

set signcolumn=yes
set mouse=a
set scrolloff=8

set showtabline=2
]])

vim.g.mapleader = " "

vim.cmd([[
au! BufWritePost $MYVIMRC source %
]])

-- Remember last position
vim.cmd([[
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

-- Edit config
vim.api.nvim_set_keymap('n', '<leader>ve', ':edit ~/.config/nvim/init.lua<cr>', {noremap=True})

-- Modes
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap=True})

-- Tabs
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<cr>', {noremap=True})

-- Buffers
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>bc', ':bd<cr>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>Q', ':bufdo bdelete<cr>', {noremap=True})

-- Change windows in Normal Mode
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', {noremap=True})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', {noremap=True})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', {noremap=True})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', {noremap=True})

-- Insert matching characters in Insert Mode
vim.api.nvim_set_keymap('i', '$1', '()<esc>i', {noremap=True})
vim.api.nvim_set_keymap('i', '$2', '[]<esc>i', {noremap=True})
vim.api.nvim_set_keymap('i', '$3', '{}<esc>i', {noremap=True})
vim.api.nvim_set_keymap('i', '$4', '{<esc>o}<esc>O', {noremap=True})
vim.api.nvim_set_keymap('i', '$q', '\'\'<esc>i', {noremap=True})
vim.api.nvim_set_keymap('i', '$Q', '\"\"<esc>i', {noremap=True})

-- Insert matching characters in Visual Mode
vim.api.nvim_set_keymap('v', '$1', '<esc>`>a)<esc>`<i(<esc>', {noremap=True})
vim.api.nvim_set_keymap('v', '$2', '<esc>`>a]<esc>`<i[<esc>', {noremap=True})
vim.api.nvim_set_keymap('v', '$3', '<esc>`>a}<esc>`<i{<esc>', {noremap=True})
vim.api.nvim_set_keymap('v', '$q', '<esc>`>a\'<esc>`<i\'<esc>', {noremap=True})
vim.api.nvim_set_keymap('v', '$Q', '<esc>`>a\"<esc>`<i\"<esc>', {noremap=True})

-- Insert lines and spaces in normal mode
vim.api.nvim_set_keymap('n', 'zj', 'o<esc>^Dk', {noremap=True})
vim.api.nvim_set_keymap('n', 'zk', 'O<esc>^Dj', {noremap=True})
vim.api.nvim_set_keymap('n', 'zh', 'i<space><esc>l', {noremap=True})
vim.api.nvim_set_keymap('n', 'zl', 'a<space><esc>h', {noremap=True})

-- Keep selection highlighted when indenting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap=True})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap=True})

-- -------------------------------------------------------------------------------------
-- Plugin: Packer
-- -------------------------------------------------------------------------------------
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
    }
  }
  use 'tpope/vim-commentary'

  use 'aonemd/quietlight.vim'
  use 'folke/tokyonight.nvim'
end)

vim.cmd([[
set termguicolors

let g:tokyonight_style = "night"
colorscheme tokyonight

"colorscheme quietlight
]])

-- -------------------------------------------------------------------------------------
-- Plugin: lualine
-- -------------------------------------------------------------------------------------
require('lualine').setup{
  options = {
    theme='tokyonight'
  }
}

-- -------------------------------------------------------------------------------------
-- Plugin: lspconfig
-- -------------------------------------------------------------------------------------
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>R', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>Telescope diagnostics<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

local servers = { 'pyright', 'gopls', }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', option = { keyword_length = 3 } },
  },
}

-- -------------------------------------------------------------------------------------
-- Plugin: Telescope
-- -------------------------------------------------------------------------------------
local telescope_theme = 'ivy'
require'telescope'.setup{
  pickers = {
    find_files = {
      theme = telescope_theme
    },
    live_grep = {
      theme = telescope_theme
    },
    buffers = {
      theme = telescope_theme
    },
    git_files = {
      theme = telescope_theme
    },
    spell_suggest = {
      theme = telescope_theme
    },
    search_history = {
      theme = telescope_theme
    },
    lsp_definitions = {
      theme = telescope_theme
    },
    lsp_references = {
      theme = telescope_theme
    },
    lsp_document_symbols = {
      theme = telescope_theme
    },
    diagnostics = { theme = telescope_theme
    },
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope git_files<CR>', {noremap=True})

vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>Telescope live_grep<CR>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', {noremap=True})

vim.api.nvim_set_keymap('n', '<leader>bb', '<cmd>Telescope buffers<CR>', {noremap=True})

vim.api.nvim_set_keymap('n', '<leader>G', '<cmd>Telescope git_branches<CR>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>Gc', '<cmd>Telescope git_commits<CR>', {noremap=True})

vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope spell_suggest<CR>', {noremap=True})
vim.api.nvim_set_keymap('n', '<leader>sh', '<cmd>Telescope search_history<CR>', {noremap=True})

-- -------------------------------------------------------------------------------------
-- Plugin: nvim-tree
-- -------------------------------------------------------------------------------------
require'nvim-tree'.setup{}
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>NvimTreeToggle<CR>', {noremap=True})

-- -------------------------------------------------------------------------------------
-- Plugin: Treesitter
-- -------------------------------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'python',
    'go',
    'lua',
    'toml',
    'yaml',
    'json',
    'c',
    'cpp',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
