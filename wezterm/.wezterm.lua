-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = "Catppuccin Frappe"

-- font configuration
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 15.0

config.hide_tab_bar_if_only_one_tab = true

-- native full screen mode on macOS
config.native_macos_fullscreen_mode = true
config.keys = {
	{ key = "f", mods = "CTRL|CMD", action = wezterm.action.ToggleFullScreen },
}

-- and finally, return the configuration to wezterm
return config
