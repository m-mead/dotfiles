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

-- Treesitter highlighting
local treesitter_group = vim.api.nvim_create_augroup("CustomTreesitterHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = treesitter_group,
  pattern = { "default", "habamax" },
  callback = function()
    local treesitter_to_vim_map = {
      ["@boolean"] = "Boolean",
      ["@comment"] = "Comment",
      ["@constant"] = "Constant",
      ["@constant.builtin"] = "Constant",
      ["@constructor"] = "Special",
      ["@field"] = "Identifier",
      ["@function"] = "Function",
      ["@function.call"] = "Function",
      ["@keyword"] = "Keyword",
      ["@keyword.return"] = "Keyword",
      ["@namespace"] = "Include",
      ["@number"] = "Number",
      ["@operator"] = "Operator",
      ["@parameter"] = "Identifier",
      ["@property"] = "Identifier",
      ["@punctuation"] = "Punctuation",
      ["@string"] = "String",
      ["@type"] = "Type",
      ["@type.builtin"] = "Type",
      ["@variable"] = "Identifier",
    }
    for g, vim_group in pairs(treesitter_to_vim_map) do
      vim.api.nvim_set_hl(0, g, { link = vim_group })
    end
  end
})

vim.cmd("colorscheme nord")
