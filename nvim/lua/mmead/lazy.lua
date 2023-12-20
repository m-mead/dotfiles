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
  'hrsh7th/cmp-buffer',
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
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  'tpope/vim-surround',
  'williamboman/mason-lspconfig.nvim',
  'williamboman/mason.nvim',
  { 'catppuccin/nvim',    name = 'catppuccin' },
  {
    'folke/which-key.nvim',
    -- event = 'VeryLazy',
    init = function()
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 300
    end,
    opts = {}
  },
})
