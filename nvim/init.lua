--[[

Author: Michael Mead

Installation
------------
This configuration is mostly self-contained and does not require manual steps
beyond installing the plugin package manager and whatever language servers you'd like.
  - Install packager.nvim: https://github.com/wbthomason/packer.nvim
  - Install language servers via :MasonInstall

--]]

-- Use space as the leader key
vim.g.mapleader = ' '

-- Use `jk` as a more ergonomic escape.
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = True, silent = True })

-- Disable netrw at startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.o.guicursor = 'i:block'

-- Remember the last position when reopening a file.
vim.cmd([[
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

-- Edit this file with a keystroke.
local opts = { noremap = True, silent = True }
vim.api.nvim_set_keymap('n', '<leader>ve', ':edit ~/.config/nvim/init.lua<cr>', opts)

-- Keybindings for moving around tabs.
vim.api.nvim_set_keymap('n', '<leader>to', ':tabnew<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnext<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>tp', ':tabprev<cr>', opts)

-- Keybindings for moving around buffers.
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<cr>', opts)

-- Keybindings for moving around windows.
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', opts)

-- Insert brace like characters when in insert mode.
vim.api.nvim_set_keymap('i', '$1', '()<esc>i', opts)
vim.api.nvim_set_keymap('i', '$2', '[]<esc>i', opts)
vim.api.nvim_set_keymap('i', '$3', '{}<esc>i', opts)
vim.api.nvim_set_keymap('i', '$4', '{<esc>o}<esc>O', opts)

-- Insert brace like characters when in visual mode.
vim.api.nvim_set_keymap('v', '$1', '<esc>`>a)<esc>`<i(<esc>', opts)
vim.api.nvim_set_keymap('v', '$2', '<esc>`>a]<esc>`<i[<esc>', opts)
vim.api.nvim_set_keymap('v', '$3', '<esc>`>a}<esc>`<i{<esc>', opts)

-- Insert blank characters without leaving insert mode.
vim.api.nvim_set_keymap('n', 'zj', 'o<esc>^Dk', opts)
vim.api.nvim_set_keymap('n', 'zk', 'O<esc>^Dj', opts)
vim.api.nvim_set_keymap('n', 'zh', 'i<space><esc>l', opts)
vim.api.nvim_set_keymap('n', 'zl', 'a<space><esc>h', opts)

-- Indent selection without leaving visual mode.
vim.api.nvim_set_keymap('v', '<', '<gv', opts)
vim.api.nvim_set_keymap('v', '>', '>gv', opts)

-- Install plugins using packer.nvim.
local use = require('packer').use
require('packer').startup(function()
  use('wbthomason/packer.nvim')

  use('L3MON4D3/LuaSnip')
  use('folke/tokyonight.nvim')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('hrsh7th/nvim-cmp')
  use('lewis6991/gitsigns.nvim')
  use('neovim/nvim-lspconfig')
  use('nvim-lua/plenary.nvim')
  use('nvim-lualine/lualine.nvim')
  use('nvim-telescope/telescope.nvim')
  use('nvim-tree/nvim-tree.lua')
  use('nvim-tree/nvim-web-devicons')
  use('nvim-treesitter/nvim-treesitter')
  use('tpope/vim-commentary')
  use('tpope/vim-dispatch')
  use('tpope/vim-sleuth')
  use('williamboman/mason-lspconfig.nvim')
  use('williamboman/mason.nvim')
end)

-- Set the colortheme.
require('tokyonight').setup({ style = 'night', light_style = 'day' })
vim.cmd([[colorscheme tokyonight-night]])

-- Use lualine for the statusline.
require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
})

-- Setup telescope fuzzy finder.
require('telescope').setup({
  defaults = {
    history = false,
    path_display = { 'shorten' },
  },
})

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find buffer' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sa', require('telescope.builtin').find_files, { desc = '[S]earch [A]ll files' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch using [G]rep' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })

-- Setup mason package manager for LSP tools (servers, linters, etc).
require('mason').setup()
require('mason-lspconfig').setup()

-- Set LSP keybindings to be attached only when client is attached.
local opts = { noremap = true, silent = true }

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>Telescope diagnostics<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Off spec. keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f3>', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Set the servers for typically used languages.
-- For more, see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = { 'pyright', 'gopls', 'clangd', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Setup autocompletion using nvim-cmp.
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
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
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
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
      name = 'vsnip',
    },
    {
      name = 'nvim_lsp_signature_help',
    },
  },
})

-- Setup treesitter syntax highlighting.
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'dockerfile',
    'go',
    'json',
    'lua',
    'python',
    'toml',
    'yaml',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Setup nvim-tree file browser.
require('nvim-tree').setup()
vim.keymap.set('n', '<leader>B', ':NvimTreeToggle<cr>', { desc = 'File [B]rowser' })

-- Setup gitsigns for git integration in the editor.
require('gitsigns').setup({
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '<leader>hD', function()
      gs.diffthis('~')
    end)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>td', gs.toggle_deleted)
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})

-- Activate a virtual environment by appending it to the path.
function python_venv_activate()
  vim.env.PATH = vim.env.PATH .. ':venv/bin'
end

vim.api.nvim_create_user_command('PyVEnvActivate', python_venv_activate, {})

-- Run the configure step for cmake.
function cmake_configure(args)
  if args then
    vim.cmd(':Dispatch mkdir -p build && cd build && cmake .. ' .. args)
  else
    vim.cmd(':Dispatch mkdir -p build && cd build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ')
  end
end

-- Run the build step for cmake.
function cmake_build(args)
  if args then
    vim.cmd(':Dispatch cd build && cmake --build . ' .. args)
  else
    vim.cmd(':Dispatch cd build && cmake --build . --target all --parallel')
  end
end

-- Omit all arguments or pass a configure argument list.
-- For example `:CMakeConfigure -DCMAKE_BUILD_TYPE=Release` will expand to `cmake .. -DCMAKE_BUILD_TYPE=Release`.
vim.api.nvim_create_user_command('CMakeConfigure', function(opts)
  cmake_configure(unpack(opts.fargs))
end, { nargs = '?' })

-- Omit all arguments or pass a build argument list.
-- For example, `:CMakeBuild --target foo` will expand to `cmake --build . --target foo`.
vim.api.nvim_create_user_command('CMakeBuild', function(opts)
  cmake_build(unpack(opts.fargs))
end, { nargs = '?' })

vim.api.nvim_create_user_command('CMakeClean', function()
  cmake_build('--target clean')
end, { nargs = 0 })

vim.keymap.set('n', '<f7>', ':CMakeBuild<cr>', { desc = 'Run CMake build asynchronously in a separate window' })
