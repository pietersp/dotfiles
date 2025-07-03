{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common/core
    # ./common/optional/desktops # No desktop for mac
    ./common/optional/ides/intellij
    ./common/optional/wezterm
  ];

  # Set a target for home-manager to link to
  # home = {
  # username = "pieter";
  #  homeDirectory = "/Users/pieter";
  #  stateVersion = "23.05"; # Please read the comment before changing.
  # };
}
