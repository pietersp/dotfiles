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
    # ./common/optional/ides/vscode
    ./common/optional/wezterm
  ];

  # This is needed because darwin installed podman but it is not present on the path.
  # Might be a better way to do this
  home.sessionPath = [ "/opt/podman/bin" ];

  home.packages = with pkgs; [
    mpv
  ];

  programs.zsh.shellAliases = {
    docker = "podman";
  };

  # Set a target for home-manager to link to
  # home = {
  # username = "pieter";
  #  homeDirectory = "/Users/pieter";
  #  stateVersion = "23.05"; # Please read the comment before changing.
  # };
}
