local statusline = require("custom.statusline")
statusline.setup_highlights()

function CustomStatusLine()
  return statusline.render()
end

vim.opt.statusline = "%!v:lua.CustomStatusLine()"

-- Autocommands
local group = vim.api.nvim_create_augroup("UserStatusLine", { clear = true })

-- Setup highlights on colorscheme load
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    statusline.setup_highlights()
  end,
})

-- Redraw status on lsp events
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "DiagnosticChanged" }, {
  group = group,
  callback = function()
    vim.cmd("redrawstatus")
  end,
})
