return {
  src = "https://github.com/nvim-mini/mini.completion",
  commit = "7c5edfc0e479dd4edd898cc9ddd1920d8c1ce420", -- v0.17.0
  config = function()
    require("mini.completion").setup()
  end,
}
