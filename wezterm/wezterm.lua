local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("HakuMoto")
config.font_size = 11.0

return config
