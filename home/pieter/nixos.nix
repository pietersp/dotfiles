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
    # common/optional/wezterm
    common/optional/ai/opencode
    "${inputs.podman-remote}/home-manager.nix"
  ];

  programs.podman-remote = {
    enable = true;
    package = inputs.podman-remote.packages.x86_64-linux.podman-remote;
  };

  # Try override for wsl
  programs.zellij.enable = lib.mkForce false;
}
