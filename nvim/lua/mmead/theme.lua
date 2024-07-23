local function load_colorscheme(plugin_name, theme, opts)
  opts = opts or {}

  if plugin_name ~= nil then
    require(plugin_name).setup(opts)
  end

  local colorscheme_cmd = 'colorscheme ' .. theme
  vim.cmd(colorscheme_cmd)

  local lualine_options = nil
  if plugin_name ~= nil then
    lualine_options = { theme = plugin_name }
  end

  require('lualine').setup({
    options = lualine_options,
    sections = {
      lualine_c = {
        { 'filename', path = 1 }
      }
    }
  })
end

-- load_colorscheme("catppuccin", 'catppuccin-latte', {})
load_colorscheme("rose-pine", 'rose-pine', {})
