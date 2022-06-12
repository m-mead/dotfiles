-- -------------------------------------------------------------------------------------
-- Author: Michael Mead
-- -------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------
-- Core
-- -------------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap=True, silent=True })

vim.o.filetype = "on"
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildmenu = true
vim.o.laststatus = 2
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
vim.o.guicursor = 'i:block'
vim.o.winbar = "%m %f"

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
  use {
    'wbthomason/packer.nvim',
    -- commit = '4dedd3b08f8c6e3f84afbce0c23b66320cd2a8f2', -- 05/17/2022
  }
  use {
    'neovim/nvim-lspconfig',
    -- commit = '629f45d7ea1b3407e7c9639a7c4c992b1cdfefee', -- 05/17/2022
  }
  use {
    'hrsh7th/nvim-cmp',
    -- commit = 'cd694b8944eb1ae98f1d0e01cf837e66b15c2857', -- 05/17/2022
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    -- commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8', -- 05/17/2022
  }
  use {
    'hrsh7th/cmp-vsnip',
    -- commit = '0abfa1860f5e095a07c477da940cfcb0d273b700', -- 05/17/2022
  }
  use {
    'nvim-lua/plenary.nvim',
    -- commit = 'bbd13b1f150910b721880bef8601dfd41784b60d', -- 05/17/2022
  }
  use {
    'nvim-telescope/telescope.nvim',
    -- commit = '01fc5a9274b553937bae3910e520732eb0a49bc6', --05/17/2022
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    -- commit = 'c004155676180a683ad424fe57294923cdf702ee', -- 05/17/2022
  }
  use {
    'kyazdani42/nvim-tree.lua',
    -- commit = '9563a11ce0c0f9f6534d241c1e3a89ae96226af1', -- 05/17/2022
  }
  use {
    'nvim-lualine/lualine.nvim',
    -- commit = 'a4e4517ac32441dd92ba869944741f0b5f468531', -- 05/17/2022
  }
  use {
    'kyazdani42/nvim-web-devicons',
    -- commit = 'cde67b5d5427daeecfd7c77cf02ded23a26980bb', -- 05/17/2022
  }
  use {
    'lewis6991/gitsigns.nvim',
    -- commit = 'ffd06e36f6067935d8cb9793905dd2e84e291310', -- 05/17/2022
  }
  use {
    'tpope/vim-commentary',
    -- commit = '3654775824337f466109f00eaf6759760f65be34', -- 05/17/2022
  }
  use {
    'tpope/vim-sleuth',
    -- commit = '1d25e8e5dc4062e38cab1a461934ee5e9d59e5a8', -- 05/17/2022
  }
  use {
    'tpope/vim-fugitive',
  }
  use {
    'catppuccin/nvim',
    -- commit = '8a67df6da476cba68ecf26a519a5279686edbd2e', -- 05/17/2022
  }
end)

-- -------------------------------------------------------------------------------------
-- Colorschemes
-- -------------------------------------------------------------------------------------
function enable_colorscheme_catppuccin()
  vim.cmd([[colorscheme catppuccin]])
end

enable_colorscheme_catppuccin()

-- -------------------------------------------------------------------------------------
-- Plugin: lualine
-- -------------------------------------------------------------------------------------
require('lualine').setup {}

-- -------------------------------------------------------------------------------------
-- Plugin: lspconfig
-- -------------------------------------------------------------------------------------
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>Telescope diagnostics<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

local servers = { 'pyright', 'gopls', 'clangd', 'rust_analyzer', }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
    vim.fn["vsnip#anonymous"](args.body)
    end,
  },
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
    {
      name = 'nvim_lsp',
      keyword_length = 2,
    },
    {
      name = 'vsnip'
    },
  },
}

-- -------------------------------------------------------------------------------------
-- Plugin: Telescope
-- -------------------------------------------------------------------------------------
require('telescope').setup {
  defaults = {
    history = false,
  },
}

local opts = { noremap=True, silent=True }
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope resume<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>Gb', '<cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Gc', '<cmd>Telescope git_commits<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Gs', '<cmd>Telescope git_status<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>Telescope spell_suggest<CR>', opts)

-- -------------------------------------------------------------------------------------
-- Plugin: nvim-tree
-- -------------------------------------------------------------------------------------
require('nvim-tree').setup {}
vim.api.nvim_set_keymap('n', '<leader>B', '<cmd>NvimTreeToggle<CR>', { noremap=True })

-- -------------------------------------------------------------------------------------
-- Plugin: Treesitter
-- -------------------------------------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'python',
    'go',
    'lua',
    'toml',
    'yaml',
    'json',
    'c',
    'cpp',
    'dockerfile',
    'bash',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- -------------------------------------------------------------------------------------
-- Plugin: Gitsigns
-- -------------------------------------------------------------------------------------
require('gitsigns').setup {
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- -------------------------------------------------------------------------------------
-- Python
-- -------------------------------------------------------------------------------------
function python_venv_activate()
  vim.env.PATH = vim.env.PATH .. ':venv/bin'
end

vim.api.nvim_create_user_command('PyVEnvActivate', python_venv_activate, {})
