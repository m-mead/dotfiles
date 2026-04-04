-- General
local general_group = vim.api.nvim_create_augroup("UserGeneral", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  pattern = "*",
  callback = function()
    -- Stop inserting comment leader on new lines
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  pattern = "*",
  callback = function()
    -- Restore last edit position
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Yank
local yank_group = vim.api.nvim_create_augroup("UserYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Treesitter
local treesitter_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
  group = treesitter_group,
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    if ft == nil or ft == "" then return end
    if vim.treesitter.language.add(ft) then
      pcall(vim.treesitter.start, 0, ft)
    end
  end,
})
