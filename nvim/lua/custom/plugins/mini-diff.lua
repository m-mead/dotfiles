return {
  "nvim-mini/mini.diff",
  commit = "fbb93ea1728e7c9d0944df8bd022a68402bd2e7e", -- v0.17.0
  config = function()
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = { add = "|", change = "|", delete = "|" },
      }
    })
  end,
}
