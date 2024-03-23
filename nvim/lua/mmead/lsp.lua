-- Automcplete for nvim APIs -- must be setup before lspconfig.
require("neodev").setup({})

require('mason').setup()
require('mason-lspconfig').setup()

-- Diagnostic keymappings
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Set LSP keybindings to be attached only when client is attached.
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'E', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gS', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>', opts)

  -- Off spec. keymaps
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<f3>', '<cmd>ClangdSwitchSourceHeader<CR>', opts)

  if vim.lsp.inlay_hint then
    vim.keymap.set("n", "<leader>hh", function()
      vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
    end, { desc = "Toggle inlay hints" })
  end
end

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

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {}

for server, _ in pairs(servers) do
  require('lspconfig')[server].setup { on_attach = on_attach, capabilities = capabilities }
end

-- Setup autocompletion using nvim-cmp.
local cmp = require('cmp')

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  mapping = {
    -- ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    -- ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
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
      keyword_length = 5
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

      vim_item.menu = ({ nvim_lsp = "[LSP]", buffer = "[Buf]" })[entry.source.name]

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
