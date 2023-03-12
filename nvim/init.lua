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
-- vim.o.laststatus = 2
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

vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<cr>', opts)

vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', opts)

vim.api.nvim_set_keymap('i', '$1', '()<esc>i', opts)
vim.api.nvim_set_keymap('i', '$2', '[]<esc>i', opts)
vim.api.nvim_set_keymap('i', '$3', '{}<esc>i', opts)
vim.api.nvim_set_keymap('i', '$4', '{<esc>o}<esc>O', opts)

vim.api.nvim_set_keymap('v', '$1', '<esc>`>a)<esc>`<i(<esc>', opts)
vim.api.nvim_set_keymap('v', '$2', '<esc>`>a]<esc>`<i[<esc>', opts)
vim.api.nvim_set_keymap('v', '$3', '<esc>`>a}<esc>`<i{<esc>', opts)

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
  }
  use {
    'neovim/nvim-lspconfig',
  }
  use {
    'hrsh7th/nvim-cmp',
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
  }
  use {
    'hrsh7th/cmp-nvim-lsp-signature-help'
  }
  use {
    'hrsh7th/cmp-vsnip',
  }
  use {
    'L3MON4D3/LuaSnip'
  }
  use {
    'nvim-lua/plenary.nvim',
  }
  use {
    'nvim-telescope/telescope.nvim',
  }
  use {
    'nvim-treesitter/nvim-treesitter',
  }
  use {
    'kyazdani42/nvim-tree.lua',
  }
  use {
    'nvim-lualine/lualine.nvim',
  }
  use {
    'kyazdani42/nvim-web-devicons',
  }
  use {
    'lewis6991/gitsigns.nvim',
  }
  use {
    'tpope/vim-commentary',
  }
  use {
    'tpope/vim-sleuth',
  }
  use {
    'catppuccin/nvim',
  }
  use {
    'folke/tokyonight.nvim'
  }
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }
end)

-- -------------------------------------------------------------------------------------
-- Colorschemes
-- -------------------------------------------------------------------------------------
require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})

vim.cmd([[colorscheme tokyonight-night]])

-- -------------------------------------------------------------------------------------
-- Plugin: lualine
-- -------------------------------------------------------------------------------------
require('lualine').setup {}

-- -------------------------------------------------------------------------------------
-- Plugin: lspconfig
-- -------------------------------------------------------------------------------------
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>Telescope diagnostics<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f3>', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
    --vim.fn["vsnip#anonymous"](args.body)
    require('luasnip').lsp_expand(args.body)
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
    {
      name = 'nvim_lsp_signature_help'
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

vim.api.nvim_set_keymap('n', '<leader>sf', '<cmd>Telescope git_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sa', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sg', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sb', '<cmd>Telescope buffers<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)

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

require("mason").setup()
require("mason-lspconfig").setup()
