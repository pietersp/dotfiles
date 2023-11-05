local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback {
    { family = "FiraCode Nerd Font", weight = "Medium", stretch = "Normal", style = "Normal" },
    "Noto Color Emoji"
  },
  enable_tab_bar = false,
  color_scheme = "Catppuccin Mocha",
  window_background_opacity = 0.7,
  audible_bell = "Disabled"
}
