return {
  {
    "nvim-mini/mini.pick",
    version = "v0.17.0",
    config = function()
      local pick = require("mini.pick")
      pick.setup({ source = { show = pick.default_show } })

      -- Keymaps
      vim.keymap.set("n", "<leader><space>", pick.builtin.buffers)
      vim.keymap.set("n", "<leader>sf", pick.builtin.files)
      vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live)
      vim.keymap.set("n", "<leader>sh", pick.builtin.help)
      vim.keymap.set("n", "<leader>sw", function() pick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end)
      vim.keymap.set("n", "sr", pick.builtin.resume)
    end,
  },
}
