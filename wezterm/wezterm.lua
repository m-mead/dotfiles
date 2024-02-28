-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'GruvboxDark'

config.font = wezterm.font('JetBrains Mono')
config.font_size = 13.0

return config
