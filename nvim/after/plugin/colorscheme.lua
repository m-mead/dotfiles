-- mini.nvim highlighting
local mini_group = vim.api.nvim_create_augroup("CustomMiniHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = mini_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "MiniPickNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "MiniPickBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { link = "Added" })
    vim.api.nvim_set_hl(0, "MiniDiffSignChange", { link = "Changed" })
    vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { link = "Removed" })
  end,
})

vim.cmd("colorscheme drift")
