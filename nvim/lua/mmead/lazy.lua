-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=v11.16.2",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  { import = 'mmead.plugins' },
  { 'lewis6991/gitsigns.nvim', version = '0.9.0' },                                      -- Latest stable as of 11/23/2024
  { 'neovim/nvim-lspconfig', version = '1.6.0' },                                        -- Latest stable as of 02/03/2025
  { 'nvim-lua/plenary.nvim', commit = '2d9b06177a975543726ce5c73fca176cedbffe9d' },      -- Latest commit as of 11/23/2024
  { 'nvim-lualine/lualine.nvim', commit = '2a5bae925481f999263d6f5ed8361baef8df4f83' },  -- Latest commit as of 11/23/2024
  { 'nvim-telescope/telescope.nvim', version = '0.1.8' },                                -- Latest stable as of 11/23/2024
  { 'folke/tokyonight.nvim', version = '4.11.0' },                                       -- Latest stable as of 02/03/2025
  { 'nvim-treesitter/nvim-treesitter', version = '0.9.3' },                              -- Latest stable as of 11/23/2024
})
