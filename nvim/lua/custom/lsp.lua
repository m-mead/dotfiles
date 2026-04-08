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

local function setup_lsp_progress()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("UserLspProgress", { clear = true }),
    callback = function(ev)
      local value = ev.data.params.value
      local history = false
      local chunks = { { value.message or "done" } }
      local opts = {
        id = "lsp." .. ev.data.client_id,
        kind = "progress",
        source = "vim.lsp",
        title = value.title,
        status = value.kind ~= "end" and "running" or "success",
        percent = value.percentage,
      }
      vim.api.nvim_echo(chunks, history, opts)
    end
  })
end

local function setup_lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Default mappings (see :h lsp-defaults)
      -- - "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
      -- - "gri" is mapped to |vim.lsp.buf.implementation()|
      -- - "grn" is mapped to |vim.lsp.buf.rename()|
      -- - "grr" is mapped to |vim.lsp.buf.references()|
      -- - "grt" is mapped to |vim.lsp.buf.type_definition()|
      -- - "grx" is mapped to |vim.lsp.codelens.run()|
      -- - "gO" is mapped to |vim.lsp.buf.document_symbol()|
      -- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
      -- - |gx| handles `textDocument/documentLink`
      map("<leader>cf", vim.lsp.buf.format, "code format")
      map("<leader>gs", vim.lsp.buf.workspace_symbol, "workspace symbols")
      map("E", function() vim.diagnostic.setloclist({ open = true }) end, "errors")
      map("grd", vim.lsp.buf.definition, "go to definition")

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
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
          group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "UserLspHighlight", buffer = event2.buf })
          end,
        })
      end

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
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
end


function M.setup()
  vim.diagnostic.config({ virtual_text = true })
  setup_lsp_progress()
  setup_lsp_attach()
  setup_user_commands()
  enable_servers()
end

M.setup()

return M
