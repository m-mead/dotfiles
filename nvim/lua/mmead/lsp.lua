-- Automcplete for nvim APIs -- must be setup before lspconfig.
require("neodev").setup({})

require('mason').setup()
require('mason-lspconfig').setup()

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Keybindings (see :h lsp-defaults)
--
-- Conditional mappings
-- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or a custom keymap for `K` exists.
-- Unconditional mappings
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'LSP type [D]efinition')
    map('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
    map('<leader>gS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'LSP workspace symbols')
    map('<leader>gs', require('telescope.builtin').lsp_document_symbols, 'LSP document symbols')
    map('E', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, 'LSP [E]rrors')
    map('gD', vim.lsp.buf.declaration, 'LSP [G]oto [D]eclaration')
    map('gI', require('telescope.builtin').lsp_implementations, 'LSP [G]oto [I]mplementation')
    map('gd', require('telescope.builtin').lsp_definitions, 'LSP [G]oto [D]efinition')
    map('grr', require('telescope.builtin').lsp_references, 'LSP [G]oto [R]eferences')

    -- Highlight LSP references on CursorHold
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>hh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, 'LSP toggle inlay [H]ints')
    end

    -- Off-spec capabilities
    if client and client.name == 'clangd' then
      map('<f3>', function() vim.cmd('ClangdSwitchSourceHeader') end, 'Switch header and source (C/C++)')
    end
  end,

})

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Server configurations:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  clangd = {},
  gopls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
  marksman = {},
  pyright = {},
  rust_analyzer = {},
  solargraph = {},
}

local lsp_servers = { 'clangd', 'lua_ls', 'gopls', 'marksman' }

if vim.fn.executable("npm") == 1 then
  table.insert(lsp_servers, 'pyright')
  table.insert(lsp_servers, 'ts_ls')
end

require('mason-lspconfig').setup {
  ensure_installed = lsp_servers,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for tsserver)
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}

require('mini.completion').setup()
