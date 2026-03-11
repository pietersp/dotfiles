{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports = [
    common/core

    common/optional/ai/opencode
    "${inputs.podman-remote}/home-manager.nix"
  ];

  programs.podman-remote = {
    enable = true;
    package = inputs.podman-remote.packages.${pkgs.stdenv.hostPlatform.system}.podman-remote;
  };

  programs.zellij.enable = lib.mkForce false;
}
