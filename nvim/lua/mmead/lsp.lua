-- Automcplete for nvim APIs -- must be setup before lspconfig.
require("neodev").setup({})

require('mason').setup()
require('mason-lspconfig').setup()

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Set LSP keybindings to be attached only when client is attached.
-- Default mappings in nvim >= 0.10:
--
-- Normal mode
--  gr     -> vim.lsp.buf.references()
--  ]d     -> vim.diagnostic.goto_next()
--  [d     -> vim.diagnostic.goto_prev()
-- <C-w>d  -> vim.diagnostic.open_float()
--
-- Insert mode
--  CTRL-S -> vim.lsp.buf.signature_help()
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
    map('<leader>gS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>gs', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('E', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, '[E]rrors')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

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
      end, '[T]oggle Inlay [H]ints')
    end

    -- Off-spec capabilities
    if client and client.name == 'clangd' then
      map('<f3>', function() vim.cmd('ClangdSwitchSourceHeader') end, 'Switch header and source (C/C++)')
    end
  end,

})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
  table.insert(lsp_servers, 'tsserver')
end

-- local mason_lspconfig = require 'mason-lspconfig'
-- mason_lspconfig.setup { ensure_installed = lsp_servers }
--
-- for server, _ in pairs(servers) do
--   server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--   require('lspconfig')[server].setup(server)
-- end
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

-- Setup autocompletion using nvim-cmp.
local cmp = require('cmp')

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- Move right in snippet
    ['<C-l>'] = cmp.mapping(function()
      if vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      end
    end, { 'i', 's' }),
    -- Move left in snippet
    ['<C-h>'] = cmp.mapping(function()
      if vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { 'i', 's' }),
  },
  sources = {
    {
      name = 'nvim_lsp'
    },
    {
      name = 'nvim_lsp_signature_help'
    },
    {
      name = 'buffer',
      keyword_length = 3
    },
    {
      name = 'path',
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    expandable_indicator = false,
    fields = { 'abbr', 'kind', 'menu' },
    format = function(entry, vim_item)
      -- Truncate menu items
      local truncated_trailer = '...'
      local max_item_length = 43 - truncated_trailer:len()
      if vim_item.abbr:len() >= max_item_length then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_item_length) .. truncated_trailer
      end

      vim_item.menu = ({ nvim_lsp = "[LSP]", buffer = "[Buf]", path = "[Path]" })[entry.source.name]

      return vim_item
    end
  },
})

vim.api.nvim_create_user_command('InstallDebugAdapaters', function(_)
  local mason_debug_adapters = { cpptools = 'OpenDebugAD7' }

  for adapter, adapter_executable in pairs(mason_debug_adapters) do
    if vim.fn.executable(adapter_executable) == 0 then
      vim.cmd('MasonInstall ' .. adapter)
    end
  end
end, { nargs = 0 })
