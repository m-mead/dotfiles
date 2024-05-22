-- Setup treesitter syntax highlighting.
local treesitter_grammars = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'dockerfile',
  'doxygen',
  'go',
  'json',
  'lua',
  'markdown',
  'python',
  'ruby',
  'toml',
  'vimdoc',
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
    -- additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
})

require 'treesitter-context'.setup { enable = false }

vim.keymap.set('n', '<leader>tt', '<cmd>TSContextToggle<cr>',
  { noremap = true, silent = true, desc = 'Toggle treesitter context' })

vim.keymap.set("n", "<leader>tc", function() require("treesitter-context").go_to_context() end,
  { noremap = true, silent = true, desc = 'Go to treesitter context' })
