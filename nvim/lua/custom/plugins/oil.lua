return {
  'stevearc/oil.nvim',
  version = '2.14.0',
  config = function()
    require('oil').setup()
  end,
  keys = {
    { "<leader>e", "<cmd>Oil<CR>", desc = "Explorer" },
  },
}
