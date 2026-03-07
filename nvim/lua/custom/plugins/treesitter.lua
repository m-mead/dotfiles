return {
  "nvim-treesitter/nvim-treesitter",
  version = "v0.10.0",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = function()
    return {
      ensure_installed = {},
      auto_install = false,
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<M-space>",
        },
      },
    }
  end,
  config = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup(opts)
  end,
}
