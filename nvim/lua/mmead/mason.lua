require('mason').setup()

local mason_language_servers = {}

if vim.fn.executable('clangd') == 0 then
  vim.list_extend(mason_language_servers, { 'clangd' })
end

require('mason-lspconfig').setup({
  ensure_installed = mason_language_servers,
})

vim.api.nvim_create_user_command('InstallDebugAdapaters', function(_)
  local mason_debug_adapters = { cpptools = 'OpenDebugAD7' }

  for adapter, adapter_executable in pairs(mason_debug_adapters) do
    if vim.fn.executable(adapter_executable) == 0 then
      vim.cmd('MasonInstall ' .. adapter)
    end
  end
end, { nargs = 0 })

