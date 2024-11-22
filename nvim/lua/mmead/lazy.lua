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
  { 'echasnovski/mini.completion', version = '*' },
  'lewis6991/gitsigns.nvim',
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',
  'stevearc/oil.nvim',
  'tpope/vim-dispatch',
  'tpope/vim-sleuth',
  'tpope/vim-surround',
})
