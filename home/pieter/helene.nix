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

  wayland.windowManager.hyprland.settings.monitor = "eDP-1, 1920x1080, 0x0, 1.0";
}
