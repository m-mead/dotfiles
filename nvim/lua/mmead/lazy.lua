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
})
