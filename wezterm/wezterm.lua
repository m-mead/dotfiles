-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "GruvboxDark"
  else
    return "Catppuccin Latte"
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 13.0

config.default_cursor_style = 'SteadyBlock'

return config
