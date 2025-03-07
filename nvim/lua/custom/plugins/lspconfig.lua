return {
  "neovim/nvim-lspconfig",
  version = "1.7.0",
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "LSP type [D]efinition")
        map("<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")
        map("<leader>gS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "LSP workspace symbols")
        map("<leader>gs", require("telescope.builtin").lsp_document_symbols, "LSP document symbols")
        map("E", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, "LSP [E]rrors")
        map("gD", vim.lsp.buf.declaration, "LSP [G]oto [D]eclaration")
        map("gI", require("telescope.builtin").lsp_implementations, "LSP [G]oto [I]mplementation")
        map("gd", require("telescope.builtin").lsp_definitions, "LSP [G]oto [D]efinition")
        map("grr", require("telescope.builtin").lsp_references, "LSP [G]oto [R]eferences")

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

    local lspconfig = require "lspconfig"

    -- C/C++
    if vim.fn.executable("clangd") == 1 then
      lspconfig.clangd.setup {
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = false
              }
            }
          }
        }
      }
    end

    -- Golang
    if vim.fn.executable("gopls") == 1 then
      lspconfig.gopls.setup {}
    end

    -- Lua
    if vim.fn.executable("lua-language-server") == 1 then
      lspconfig.lua_ls.setup {
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
      }
    end

    -- Python
    if vim.fn.executable("pyright") == 1 then
      lspconfig.pyright.setup {}
    end

    if vim.fn.executable("ruff") == 1 then
      lspconfig.ruff.setup {}
    end

    -- Rust
    if vim.fn.executable("rust-analyzer") == 1 then
      lspconfig.rust_analyzer.setup {
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = false
              }
            }
          }
        }
      }
    end

    -- Ruby
    if vim.fn.executable("ruby-lsp") == 1 then
      lspconfig.ruby_lsp.setup {}
    end
  end
}
