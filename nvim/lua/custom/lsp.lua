local M = {}

local function enable_servers()
  local servers = {
    "clangd",
    "gopls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "ts_ls",
  }

  for _, server in ipairs(servers) do
    local config = vim.lsp.config[server]
    local command = config and config.cmd
    local executable = type(command) == "table" and command[1] or command
    if executable and vim.fn.executable(executable) == 1 then
      vim.lsp.enable(server)
    end
  end
end

local function setup_lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("<leader>D", vim.lsp.buf.type_definition, "type definition")
      map("<leader>cf", vim.lsp.buf.format, "code format")
      map("<leader>gs", vim.lsp.buf.workspace_symbol, "workspace symbols")
      map("E", function()
        vim.diagnostic.setloclist({ open = true })
      end, "errors")
      map("gD", vim.lsp.buf.declaration, "declaration")
      map("gI", vim.lsp.buf.implementation, "implementation")
      map("gd", vim.lsp.buf.definition, "definition")
      map("grr", vim.lsp.buf.references, "references")

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

  vim.api.nvim_create_user_command("LspEnable", function()
    enable_servers()
  end, { desc = "Enable LSP servers" })
end


function M.setup()
  vim.diagnostic.config({ virtual_text = true })
  setup_lsp_attach()
  setup_user_commands()

  -- Keybindings
  vim.keymap.set("n", "<leader>l", enable_servers, { desc = "LSP: enable servers" })
end

return M
