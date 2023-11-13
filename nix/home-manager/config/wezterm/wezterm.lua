local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback {
    {
      family = "Monaspace Neon",
      weight = "Medium",
      stretch = "Normal",
      style = "Normal",
      harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig' }
    },
    { family = "FiraCode Nerd Font", weight = "Medium", stretch = "Normal", style = "Normal" },
    "Noto Color Emoji"
  },
  font_size = 16.0,
  enable_tab_bar = false,
  -- default_domain = "WSL:Ubuntu",
  --window_background_opacity = 0.1,
  -- window_background_opacity = 1,
  -- win32_system_backdrop = 'Tabbed',
  color_scheme = "Catppuccin Mocha",
  audible_bell = "Disabled",
  adjust_window_size_when_changing_font_size = false
}
