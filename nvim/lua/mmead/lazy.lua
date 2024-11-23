-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=v11.14.2",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Setup plugins
-- Stable, tagged releases are preferred; in the case where the latest stable is too old, pin the latest known working commit.
-- Lazy will check for available updates, so its relatively easy to bump the versions when ready.
require("lazy").setup({
  { 'echasnovski/mini.completion', version = '0.14.0' },                                 -- Latest stable as of 11/23/2024
  { 'lewis6991/gitsigns.nvim', version = '0.9.0' },                                      -- Latest stable as of 11/23/2024
  { 'neovim/nvim-lspconfig', version = '1.0.0' },                                        -- Latest stable as of 11/23/2024
  { 'nvim-lua/plenary.nvim', commit = '2d9b06177a975543726ce5c73fca176cedbffe9d' },      -- Latest commit as of 11/23/2024
  { 'nvim-lualine/lualine.nvim', commit = '2a5bae925481f999263d6f5ed8361baef8df4f83' },  -- Latest commit as of 11/23/2024
  { 'nvim-telescope/telescope.nvim', version = '0.1.8' },                                -- Latest stable as of 11/23/2024
  { 'folke/tokyonight.nvim', version = '4.10.0' },                                       -- Latest stable as of 11/23/2024
  { 'nvim-treesitter/nvim-treesitter', version = '0.9.3' },                              -- Latest stable as of 11/23/2024
  { 'stevearc/oil.nvim', version = '2.13.0' },                                           -- Latest commit as of 11/23/2024
  { 'tpope/vim-dadbod', commit = 'fe5a55e92b2dded7c404006147ef97fb073d8b1b' },           -- Latest commit as of 11/23/2024
  { 'tpope/vim-dispatch', commit = 'a2ff28abdb2d89725192db5b8562977d392a4d3f' },         -- Latest commit as of 11/23/2024
  { 'tpope/vim-sleuth', commit = 'be69bff86754b1aa5adcbb527d7fcd1635a84080' },           -- Latest commit as of 11/23/2024
  { 'tpope/vim-surround', version = '2.2'},                                              -- Latest stable as of 11/23/2024
})
