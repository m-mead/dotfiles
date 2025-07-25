return {
  "nvim-treesitter/nvim-treesitter-context",
  version = "1.1.0",
  config = function()
    require "treesitter-context".setup {
      enable = true,
    }

    vim.keymap.set("n", "[s", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true })
  end
}
