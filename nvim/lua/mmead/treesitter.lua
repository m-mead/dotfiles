-- Setup treesitter syntax highlighting.
local treesitter_grammars = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'dockerfile',
  'go',
  'json',
  'lua',
  'markdown',
  'python',
  'ruby',
  'toml',
  'yaml',
}

-- Building the rust grammer requires cargo or install will hang.
if vim.fn.executable('cargo') then
  vim.list_extend(treesitter_grammars, { 'rust' })
end

require('nvim-treesitter.configs').setup({
  ensure_installed = treesitter_grammars,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
