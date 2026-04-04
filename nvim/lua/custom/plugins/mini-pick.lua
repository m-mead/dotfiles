return {
  src = "https://github.com/nvim-mini/mini.pick",
  version = "6b7974543b17cf2e294993fc3d8545a342258232",  -- v0.17.0
  config = function()
    local pick = require("mini.pick")
    pick.setup({
      source = {
        show = pick.default_show,
      },
      mappings = {
        choose_all = {
          char = "<C-q>",
          func = function()
            local mappings = pick.get_picker_opts().mappings
            vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
          end
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader><space>", pick.builtin.buffers)
    vim.keymap.set("n", "<leader>sf", pick.builtin.files)
    vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live)
    vim.keymap.set("n", "<leader>sh", pick.builtin.help)
    vim.keymap.set("n", "sr", pick.builtin.resume)

    vim.keymap.set("n", "<leader>sw", function()
      pick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
    end)

    vim.keymap.set("n", "<leader>s0", function()
      pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
    end)

    vim.keymap.set("n", "<leader>/", function()
      pick.builtin.grep_live({ globs = { vim.fn.expand("%") } })
    end)
  end,
}
