return {
  "neovim/nvim-lspconfig",
  version = "2.6.0",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Keymaps
        map("<leader>D", vim.lsp.buf.type_definition, "type definition")
        map("<leader>cf", vim.lsp.buf.format, "code format")
        map("<leader>gs", vim.lsp.buf.workspace_symbol, "workspace symbols")
        map("E", function() vim.diagnostic.setloclist({ open = true }) end, "errors")
        map("gD", vim.lsp.buf.declaration, "declaration")
        map("gI", vim.lsp.buf.implementation, "implementation")
        map("gd", vim.lsp.buf.definition, "definition")
        map("grr", vim.lsp.buf.references, "references")

        vim.diagnostic.config({ virtual_text = true })

        -- Highlight LSP references on CursorHold
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
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(false)
          map("<leader>hh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "LSP toggle inlay [H]ints")
        end

        -- Off-spec capabilities
        if client and client.name == "clangd" then
          map("<f3>", function() vim.cmd("ClangdSwitchSourceHeader") end, "Switch header and source (C/C++)")
        end
      end,
    })

    -- Server configurations:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/config.md

    -- C/C++
    if vim.fn.executable("clangd") == 1 then
      vim.lsp.config("clangd", {
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = false
              }
            }
          }
        }
      })
      vim.lsp.enable("clangd", true)
    end

    -- Golang
    if vim.fn.executable("gopls") == 1 then
      vim.lsp.enable("gopls", true)
    end

    -- Lua
    if vim.fn.executable("lua-language-server") == 1 then
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                "vim",
                "require"
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls", true)
    end

    -- Python
    if vim.fn.executable("pyright") == 1 then
      vim.lsp.enable("pyright", true)
    end

    if vim.fn.executable("ruff") == 1 then
      vim.lsp.enable("ruff", true)
    end

    -- Rust
    if vim.fn.executable("rust-analyzer") == 1 then
      vim.lsp.config("rust_analyzer", {
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = false
              }
            }
          }
        }
      })
      vim.lsp.enable("rust_analyzer", true)
    end

    -- Ruby
    if vim.fn.executable("ruby-lsp") == 1 then
      vim.lsp.config("ruby_lsp", {})
      vim.lsp.enable("ruby_lsp", true)
    end

    if vim.fn.executable("typescript-language-server") == 1 then
      vim.lsp.config("ts_ls", {})
      vim.lsp.enable("ts_ls", true)
    end
  end
}
