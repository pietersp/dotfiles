{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports = [
    # Required configs
    common/core #required

    # Host specific optional configs
    common/optional/wezterm
    common/optional/desktops/hyprland
    common/optional/ides/intellij
  ];
  home.packages = with pkgs; [
    keepass
  ];

  gtk.enable = true;
  gtk.theme.package = pkgs.catppuccin-gtk;
  gtk.theme.name = "Catppuccin-Macchiato-Compact-Pink-Dark";
  qt.enable = true;
  qt.style.package = pkgs.catppuccin-kvantum;
  qt.style.name = "catppuccin-kvantum";
  qt.platformTheme.name = "gtk";



  wayland.windowManager.hyprland.settings.monitor = "eDP-1, 1920x1080, 0x0, 1.0";
}
