{
  pkgs,
  lib,
  ...
}: {

  imports = [ ./binds.nix ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
  };

  settings = {
    env = [
      "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
      # "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
      # "MOZ_WEBRENDER, 1" # for firefox to run on wayland
      # "XDG_SESSION_TYPE,wayland"
      # "WLR_NO_HARDWARE_CURSORS,1"
      # "WLR_RENDERER_ALLOW_SOFTWARE,1"
      # "QT_QPA_PLATFORM,wayland"
    ];
  };
}
