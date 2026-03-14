-- Keybindings for moving around tabs
vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", { noremap = true, silent = true, desc = "tab next" })
vim.keymap.set("n", "[t", "<cmd>tabprev<cr>", { noremap = true, silent = true, desc = "tab previous" })

-- Keybindings for moving around buffers
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { noremap = true, silent = true, desc = "buffer next" })
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { noremap = true, silent = true, desc = "buffer previous" })

-- Insert blank characters without leaving insert mode
vim.keymap.set("n", "]<Space>", "o<Esc>k", { noremap = true, silent = true, desc = "insert blank line below" })
vim.keymap.set("n", "[<Space>", "O<Esc>j", { noremap = true, silent = true, desc = "insert blank line above" })

-- Indent selection without leaving visual mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "shift selection left and hold on" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "shift select right and hold on" })

-- Easier terminal exit
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Jump between quickfix list items
vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>", { desc = "next quickfix list item" })
vim.keymap.set("n", "<M-k>", "<cmd>cprevious<cr>", { desc = "previous quickfix list item" })

-- Diagnostic keymappings
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

-- System clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { noremap = true, silent = true })

-- Netrw
vim.keymap.set("n", "<leader>e", function()
  local filename = vim.fn.expand("%:t")
  local directory = vim.fn.expand("%:p:h")

  if directory == "" then
    directory = vim.fn.getcwd()
  end

  vim.cmd("Explore " .. vim.fn.fnameescape(directory))

  -- Move the cursor to the current file
  if filename == "" then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local function normalize_entry(name)
    return name:gsub("%s+%-%>.*$", ""):gsub("/$", ""):gsub("[*@|=]$", "")
  end

  for lnum, line in ipairs(lines) do
    local text = vim.trim(line)
    local entry = normalize_entry(text)
    local last_field = text:match("([^%s]+)$")
    if entry == filename or (last_field and normalize_entry(last_field) == filename) then
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      break
    end
  end
end, { noremap = true, silent = true, desc = "open netrw at current file" })

-- Spelling
vim.keymap.set("n", "yos", "<cmd>setlocal spell!<bar>setlocal spell?<cr>",
  { noremap = true, silent = true, desc = "spell toggle" })

vim.keymap.set("n", "]os", "<cmd>setlocal spell<bar>setlocal spell?<cr>",
  { noremap = true, silent = true, desc = "spell on" })

vim.keymap.set("n", "[os", "<cmd>setlocal nospell<bar>setlocal spell?<cr>",
  { noremap = true, silent = true, desc = "spell off" })
