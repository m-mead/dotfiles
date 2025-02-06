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
  { 'nvim-lua/plenary.nvim', commit = '2d9b06177a975543726ce5c73fca176cedbffe9d' },      -- Latest commit as of 11/23/2024
  { 'nvim-telescope/telescope.nvim', version = '0.1.8' },                                -- Latest stable as of 11/23/2024
  { 'nvim-treesitter/nvim-treesitter', version = '0.9.3' },                              -- Latest stable as of 11/23/2024
})
