-- -------------------------------------------------------------------------------------
-- Author: Michael Mead
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- Core
-- -------------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap=True, silent=True})

vim.o.filetype = "on"
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildmenu = true
vim.o.laststatus = 2
vim.o.errorbells = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
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
vim.o.showtabline = 2
vim.o.cursorline = true
vim.o.termguicolors = true

vim.cmd([[
au! BufWritePost $MYVIMRC source %
]])

-- Remember last position
vim.cmd([[
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

local opts = { noremap = True, silent=True }
vim.api.nvim_set_keymap('n', '<leader>ve', ':edit ~/.config/nvim/init.lua<cr>', opts)

vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<cr>', opts)

vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>bc', ':bd<cr>', opts)

vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', opts)

vim.api.nvim_set_keymap('i', '$1', '()<esc>i', opts)
vim.api.nvim_set_keymap('i', '$2', '[]<esc>i', opts)
vim.api.nvim_set_keymap('i', '$3', '{}<esc>i', opts)
vim.api.nvim_set_keymap('i', '$4', '{<esc>o}<esc>O', opts)
vim.api.nvim_set_keymap('i', '$q', '\'\'<esc>i', opts)
vim.api.nvim_set_keymap('i', '$Q', '\"\"<esc>i', opts)

vim.api.nvim_set_keymap('v', '$1', '<esc>`>a)<esc>`<i(<esc>', opts)
vim.api.nvim_set_keymap('v', '$2', '<esc>`>a]<esc>`<i[<esc>', opts)
vim.api.nvim_set_keymap('v', '$3', '<esc>`>a}<esc>`<i{<esc>', opts)
vim.api.nvim_set_keymap('v', '$q', '<esc>`>a\'<esc>`<i\'<esc>', opts)
vim.api.nvim_set_keymap('v', '$Q', '<esc>`>a\"<esc>`<i\"<esc>', opts)

vim.api.nvim_set_keymap('n', 'zj', 'o<esc>^Dk', opts)
vim.api.nvim_set_keymap('n', 'zk', 'O<esc>^Dj', opts)
vim.api.nvim_set_keymap('n', 'zh', 'i<space><esc>l', opts)
vim.api.nvim_set_keymap('n', 'zl', 'a<space><esc>h', opts)

vim.api.nvim_set_keymap('v', '<', '<gv', opts)
vim.api.nvim_set_keymap('v', '>', '>gv', opts)

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
    requires = {
      'nvim-lua/plenary.nvim'
    }
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
  use 'folke/tokyonight.nvim'
  use 'aonemd/quietlight.vim'
end)

-- -------------------------------------------------------------------------------------
-- Plugin: tokyonight
-- -------------------------------------------------------------------------------------
vim.g.tokyonight_style = 'night'
vim.cmd([[colorscheme tokyonight]])

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

local opts = { noremap=True, silent=True }
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope git_files<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>bb', '<cmd>Telescope buffers<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>G', '<cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Gs', '<cmd>Telescope git_status<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Gc', '<cmd>Telescope git_commits<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope spell_suggest<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sh', '<cmd>Telescope search_history<CR>', opts)

-- -------------------------------------------------------------------------------------
-- Plugin: nvim-tree
-- -------------------------------------------------------------------------------------
require'nvim-tree'.setup{}
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>NvimTreeToggle<CR>', { noremap=True })

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
