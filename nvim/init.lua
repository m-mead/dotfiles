-- Author: Michael Mead

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

-- Lazy load plugins
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
  'mfussenegger/nvim-dap',
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
  { 'rose-pine/neovim', name = 'rose-pine' },
})

-- Colorschemes
local function load_colorscheme(plugin_name, theme, opts)
  opts = opts or {}
  require(plugin_name).setup(opts)

  local colorscheme_cmd = 'colorscheme ' .. theme
  vim.cmd(colorscheme_cmd)

  require('lualine').setup({
    options = {
      theme = plugin_name,
    },
    sections = {
      lualine_c = {
        { 'filename', path = 1 }
      }
    }
  })
end

-- Dark themes
load_colorscheme('rose-pine', 'rose-pine', {})
-- load_colorscheme('kanagawa', 'kanagawa', {})
-- load_colorscheme('tokyonight', 'tokyonight-night', { style = 'night', light_style = 'day' })

-- Setup telescope fuzzy finder.
require('telescope').setup({})

local telescope_builtin = require('telescope.builtin')
local telescope_themes = require('telescope.themes')

vim.keymap.set('n', '<leader>!', telescope_builtin.resume, { desc = '[!] Resume previous search' })

-- Buffers
vim.keymap.set('n', '<leader><space>', function()
  telescope_builtin.buffers(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[ ] Find buffer' })

-- Old files
vim.keymap.set('n', '<leader>?', function()
  telescope_builtin.oldfiles(telescope_themes.get_dropdown({ previewer = false, only_cwd = true, cwd = vim.fn.getcwd() }))
end, { desc = '[?] Find recently opened files' })

-- All files
vim.keymap.set('n', '<leader>sa', function()
  telescope_builtin.find_files(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [A]ll files' })

-- Git files
vim.keymap.set('n', '<leader>sf', function()
  telescope_builtin.git_files(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [F]iles' })

-- Commands
vim.keymap.set('n', '<leader>sc', function()
  telescope_builtin.command_history(telescope_themes.get_dropdown({ previewer = false }))
end, { desc = '[S]earch [C]ommand history' })

vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch using [G]rep' })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sj', telescope_builtin.jumplist, { desc = '[S]earch [J]ump list' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch [W]ord' })

-- Setup mason package manager for LSP tools (servers, linters, etc).
require('mason').setup()

local mason_language_servers = {}

if vim.fn.executable('clangd') == 0 then
  vim.list_extend(mason_language_servers, { 'clangd' })
end

require('mason-lspconfig').setup({
  ensure_installed = mason_language_servers,
})

vim.api.nvim_create_user_command('InstallDebugAdapaters', function(_)
  local mason_debug_adapters = { cpptools = 'OpenDebugAD7' }

  for adapter, adapter_executable in pairs(mason_debug_adapters) do
    if vim.fn.executable(adapter_executable) == 0 then
      vim.cmd('MasonInstall ' .. adapter)
    end
  end
end, { nargs = 0 })

-- Automcplete for nvim APIs -- must be setup before lspconfig.
require("neodev").setup({})

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Set LSP keybindings to be attached only when client is attached.
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr, 'n', 'E', '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0})<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
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
vim.api.nvim_set_keymap("i", "<C-y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Setup autocompletion using nvim-cmp.
local cmp = require('cmp')

local cmp_kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- Truncate menu items
      local truncated_trailer = '...'
      local max_item_length = 43 - truncated_trailer:len()
      if vim_item.abbr:len() >= max_item_length then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_item_length) .. truncated_trailer
      end

      -- Add icons to completion items
      vim_item.kind = string.format('%s %s', cmp_kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({ nvim_lsp = "[LSP]" })[entry.source.name]

      return vim_item
    end
  },
})

-- Setup treesitter syntax highlighting.
local treesitter_grammars = {
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
  'toml',
  'yaml',
}

-- Building the rust grammer requires cargo or install will hang.
if vim.fn.executable('cargo') then
  vim.list_extend(treesitter_grammars, { 'rust' })
end

require('nvim-treesitter.configs').setup({
  ensure_installed = treesitter_grammars,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Setup nvim-tree file browser.
require('nvim-tree').setup({})
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

-- Debug adapter
local dap = require('dap')

-- C++ configuration
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

-- dap keybindings
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dB', function() require('dap').set_breakpoint() end)
-- vim.keymap.set( 'n', '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({ 'n', 'v' }, '<leader>dp', function() require('dap.ui.widgets').preview() end)

vim.keymap.set('n', '<leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)

vim.keymap.set('n', '<leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

-- Async commands
local function dispatch(args)
  vim.cmd(':Dispatch ' .. args)
end

-- CMake commands
-- TODO: Use autocommands to only populate these commands when the filetype is right.
local function cmake_configure(args)
  if args then
    dispatch('mkdir -p build && cd build && cmake .. ' .. args)
  else
    dispatch('mkdir -p build && cd build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON')
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

local function cmake_list_targets(build_dir)
  build_dir = build_dir or vim.fn.getcwd() .. '/build'

  local Job = require 'plenary.job'

  local stdout = {}
  local is_okay = false

  Job:new({
    command = 'cmake',
    args = { '--build', '.', '--target', 'help' },
    cwd = build_dir,
    on_exit = function(_, return_val)
      is_okay = (return_val == 0)
    end,
    on_stdout = function(_, data)
      vim.list_extend(stdout, { data })
    end,
  }):sync()

  if not is_okay then
    return {}
  end

  local targets = {}
  for _, v in ipairs(stdout) do
    if vim.startswith(v, '...') then
      vim.list_extend(targets, { vim.split(v, ' ')[2] })
    end
  end

  return targets
end

vim.api.nvim_create_user_command('CMakeListTargets', function(opts)
  local targets = cmake_list_targets(unpack(opts.fargs))

  for _, v in ipairs(targets) do
    print(v)
  end
end, { nargs = '?' })
