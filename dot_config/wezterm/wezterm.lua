-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font 'RobotoMono Nerd Font Mono'
config.font_size = 15
config.enable_kitty_graphics = true
config.enable_tab_bar = false

local theme = require('dynamic_theme')
config.color_scheme = "" .. theme

-- and finally, return the configuration to wezterm
return config
