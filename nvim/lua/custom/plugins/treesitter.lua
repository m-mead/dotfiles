return {
  'nvim-treesitter/nvim-treesitter',
  version = '0.9.3',
  config = function()
    -- Setup treesitter syntax highlighting.
    local treesitter_grammars = {
      'bash',
      'c',
      'cpp',
      'go',
      'javascript',
      'json',
      'lua',
      'markdown',
      'python',
      'swift',
      'typescript',
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
      indent = { enable = false },
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
  end
}
