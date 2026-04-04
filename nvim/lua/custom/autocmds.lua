-- Stop inserting comments on new lines when previous line is commented.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Remember the last position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Highlight text on yank.
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Treesitter
local treesitter_group = vim.api.nvim_create_augroup("TSAutoStart", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
  group = treesitter_group,
  callback = function()
    local ft = vim.bo.filetype
    if ft == nil or ft == "" then
      return
    end

    if vim.treesitter.language.add(ft) then
      pcall(vim.treesitter.start, 0, ft)
    end
  end,
})
