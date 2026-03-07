local statusline = require("custom.statusline")
statusline.setup_highlights()

function CustomStatusLine()
  return statusline.render()
end

vim.opt.statusline = "%!v:lua.CustomStatusLine()"

-- Setup highlights on colorscheme load
local group = vim.api.nvim_create_augroup("CustomStatusLine", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    statusline.setup_highlights()
  end,
})
