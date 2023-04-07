-- Author: Michael Mead

-- Use space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Use `jk` as a more ergonomic escape.
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', 'jk', [[<C-\><C-n>]], { noremap = true, silent = true })

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
vim.o.guicursor = 'i:block,a:blinkon1'

-- Stop inserting comments on new lines when previous line is commented.
vim.opt.formatoptions:remove { 'c', 'r', 'o' }

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
vim.api.nvim_set_keymap('n', '<leader>bn', ':bn<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bp<cr>', { noremap = true, silent = true })

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

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'folke/neodev.nvim',
  'folke/tokyonight.nvim',
  'github/copilot.vim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'lewis6991/gitsigns.nvim',
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nvim-treesitter/nvim-treesitter',
  'rebelot/kanagawa.nvim',
  'tpope/vim-commentary',
  'tpope/vim-dispatch',
  'tpope/vim-sleuth',
  'williamboman/mason-lspconfig.nvim',
  'williamboman/mason.nvim',
})

local function load_colorscheme(plugin_name, theme, opts)
  opts = opts or {}
  require(plugin_name).setup(opts)

  local colorscheme_cmd = 'colorscheme ' .. theme
  vim.cmd(colorscheme_cmd)

  require('lualine').setup({
    options = {
      theme = theme,
      section_separators = '',
      component_separators = ''
    },
    sections = {
      lualine_c = {
        { 'filename', path = 1 }
      }
    }
  })
end

load_colorscheme('kanagawa', 'kanagawa', {})
-- load_colorscheme('tokyonight', 'tokyonight-night', { style = 'night', light_style = 'day' })

-- Setup telescope fuzzy finder.
require('telescope').setup({})

vim.keymap.set('n', '<leader>!', require('telescope.builtin').resume, { desc = '[!] Resume previous search' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find buffer' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sa', require('telescope.builtin').find_files, { desc = '[S]earch [A]ll files' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').command_history, { desc = '[S]earch [C]ommand history' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch using [G]rep' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })

-- Setup mason package manager for LSP tools (servers, linters, etc).
require('mason').setup()
require('mason-lspconfig').setup()

-- Automcplete for nvim APIs -- must be setup before lspconfig.
require("neodev").setup({})

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Set LSP keybindings to be attached only when client is attached.
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'E', '<cmd>Telescope diagnostics<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)

  -- Off spec. keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f3>', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Server configurations:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  'clangd',
  'gopls',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'solargraph',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- Copilot
vim.cmd([[
  imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true
]])

-- Setup autocompletion using nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.b._copilot_suggestion ~= nil then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn['copilot#Accept'](), true, true, true), '')
      else
        fallback()
      end
    end,
    -- ['<S-Tab>'] = function(fallback)
    ['<C-p>'] = function(fallback)
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
    },
    {
      name = 'nvim_lsp_signature_help',
    },
  },
  experimental = {
    native_menu = false,
  },
  formatting = {
    format = function(entry, vim_item)
      -- Truncate menu so it does not overflow.
      local fixed_preview_width = 40
      if vim_item.abbr:len() >= fixed_preview_width then
        vim_item.abbr = vim_item.abbr .. '...'
      else
        vim_item.abbr = string.sub(vim_item.abbr, 1, fixed_preview_width)
      end
      return vim_item
    end
  }
})

-- Setup treesitter syntax highlighting.
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'dockerfile',
    'go',
    'json',
    'lua',
    'python',
    'ruby',
    'rust',
    'toml',
    'yaml',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Setup nvim-tree file browser.
require('nvim-tree').setup({
  view = { side = 'right' }
})
vim.keymap.set('n', '<leader>B', ':NvimTreeToggle<cr>', { desc = 'File [B]rowser' })

-- Setup gitsigns for git integration in the editor.
require('gitsigns').setup({
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
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

local function dispatch(args)
  vim.cmd(':Dispatch ' .. args)
end

local function cmake_configure(args)
  if args then
    dispatch('mkdir -p build && cd build && cmake .. ' .. args)
  else
    dispatch('mkdir -p build && cd build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ')
  end
end

local function cmake_build(args)
  if args then
    dispatch('cd build && cmake --build . ' .. args)
  else
    dispatch('cd build && cmake --build . --target all --parallel')
  end
end

vim.api.nvim_create_user_command('CMakeConfigure', function(opts)
  cmake_configure(unpack(opts.fargs))
end, { nargs = '?' })

vim.api.nvim_create_user_command('CMakeBuild', function(opts)
  cmake_build(unpack(opts.fargs))
end, { nargs = '?' })

vim.api.nvim_create_user_command('CMakeClean', function()
  cmake_build('--target clean')
end, { nargs = 0 })

vim.api.nvim_create_user_command('CMakeListTargets', function()
  cmake_build('--target help')
end, { nargs = 0 })

vim.api.nvim_create_user_command('CTest', function()
  dispatch('cd build && ctest')
end, { nargs = 0 })

vim.keymap.set('n', '<f7>', ':CMakeBuild<cr>', { desc = 'Run CMake build asynchronously in a separate window' })
