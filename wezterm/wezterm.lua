-- Pull in the wezterm API
local wezterm = require "wezterm"

local config = wezterm.config_builder()

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "tokyonight_night"
  else
    return "Catppuccin Latte"
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.5

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.audible_bell = "Disabled"

return config
