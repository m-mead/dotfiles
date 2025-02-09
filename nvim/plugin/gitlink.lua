local gitlink = require("custom.gitlink")
gitlink.setup({})

vim.keymap.set("n", "<leader>gxx", gitlink.open, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gxy", gitlink.system_clipboard, { noremap = true, silent = true })
