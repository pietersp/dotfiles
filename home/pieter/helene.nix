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
  ];
}
