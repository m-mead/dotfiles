local group = vim.api.nvim_create_augroup("DefaultColorschemeTreesitterHighlights", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "default",
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
    for treesitter_group, vim_group in pairs(treesitter_to_vim_map) do
      vim.api.nvim_set_hl(0, treesitter_group, { link = vim_group })
    end
  end
})

vim.cmd("colorscheme default")
