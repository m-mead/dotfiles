return {
  src = "nvim.undotree",
  config = function()
    vim.keymap.set("n", "<leader>u", function() require("undotree").open() end, { noremap = true, silent = true })
  end
}
