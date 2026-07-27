{lib, ...}: {
  programs.wezterm = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      font = lib.generators.mkLuaInline ''
        wezterm.font_with_fallback {
          {
            family = "FiraCode Nerd Font",
            weight = "Medium",
            stretch = "Normal",
            style = "Normal",
          },
          "Noto Color Emoji",
        }
      '';
      front_end = "WebGpu";
      font_size = 12.0;
      enable_tab_bar = false;
      color_scheme = "Catppuccin Mocha";
      audible_bell = "Disabled";
      adjust_window_size_when_changing_font_size = false;
      enable_wayland = false;
    };
  };

  # The settings already select the Catppuccin color scheme.
  catppuccin.wezterm.enable = false;
}
