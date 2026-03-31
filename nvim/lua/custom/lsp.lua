local M = {}

local servers = {
  "clangd",
  "gopls",
  "lua_ls",
  "ruby_lsp",
  "ruff",
  "rust_analyzer",
  "ts_ls",
  "ty",
}

local function enable_servers()
  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
end

local function disable_servers()
  local failures = {}
  for _, server in ipairs(servers) do
    local ok = pcall(vim.lsp.enable, server, false)
    if not ok then
      table.insert(failures, server)
    end
  end

  if #failures > 0 then
    vim.notify("Failed to disable servers: " .. table.concat(failures, ", "), vim.log.levels.ERROR)
  end
end

local function any_server_enabled()
  for _, server in ipairs(servers) do
    if vim.lsp.is_enabled(server) then
      return true
    end
  end
  return false
end

local function setup_lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("<leader>cf", vim.lsp.buf.format, "code format")
      map("<leader>gs", vim.lsp.buf.workspace_symbol, "workspace symbols")
      map("E", function()
        vim.diagnostic.setloclist({ open = true })
      end, "errors")

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
          end,
        })
      end

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
        map("<leader>hh", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
        end, "toggle inlay hints")
      end
    end,
  })
end

local function setup_user_commands()
  vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("checkhealth vim.lsp")
  end, { desc = "Show LSP info" })

  vim.api.nvim_create_user_command("LspClearLog", function()
    local log_path = vim.lsp.log.get_filename()
    local ok, err = pcall(vim.fn.writefile, {}, log_path)
    if not ok then
      vim.notify("Failed to clear LSP log: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end, { desc = "Clear LSP log" })

  vim.api.nvim_create_user_command("LspStart", function()
    enable_servers()
  end, { desc = "Start LSP" })

  vim.api.nvim_create_user_command("LspStop", function()
    disable_servers()
  end, { desc = "Stop LSP" })
end


function M.setup()
  vim.diagnostic.config({ virtual_text = true })

  setup_lsp_attach()
  setup_user_commands()
  enable_servers()

  -- Keybindings
  vim.keymap.set("n", "<leader>l", function()
    if any_server_enabled() then
      disable_servers()
    else
      enable_servers()
    end
  end, { desc = "LSP toggle" })
end

return M
