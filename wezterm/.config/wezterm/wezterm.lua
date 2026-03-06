local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Gruvbox dark, hard (base16)'

-- Font Configuration
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = 11.0
config.line_height = 1.4

-- Rendering Tweaks
config.underline_thickness = "200%"
config.enable_wayland = true
-- config.window_decorations = "NONE"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

-- UI
-- config.window_background_opacity = 0.90

-- Tab Bar Configuration
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Keybindings
config.keys = {
  { key = 'q', mods = 'CTRL', action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
}

return config
