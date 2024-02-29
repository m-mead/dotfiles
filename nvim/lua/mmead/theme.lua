local function load_colorscheme(plugin_name, theme, opts)
  opts = opts or {}
  require(plugin_name).setup(opts)

  local colorscheme_cmd = 'colorscheme ' .. theme
  vim.cmd(colorscheme_cmd)

  require('lualine').setup({
    options = {
      theme = plugin_name,
    },
    sections = {
      lualine_c = {
        { 'filename', path = 1 }
      }
    }
  })
end

-- Dark themes
-- vim.o.background = 'dark'
-- load_colorscheme('gruvbox', 'gruvbox', {})

-- load_colorscheme('kanagawa', 'kanagawa-dragon', {})
-- load_colorscheme('tokyonight', 'tokyonight-night', { style = 'night', light_style = 'day' })

load_colorscheme('catppuccin', 'catppuccin-mocha', {})

-- Light themes
-- load_colorscheme('catppuccin', 'catppuccin-latte', {})
