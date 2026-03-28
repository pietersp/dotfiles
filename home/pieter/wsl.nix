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
    common/optional/ai/gemini
    common/optional/ai/metals-mcp
    "${inputs.podman-remote}/home-manager.nix"
  ];

  targets.genericLinux.enable = true;

  programs.podman-remote = {
    enable = true;
    package = inputs.podman-remote.packages.${pkgs.stdenv.hostPlatform.system}.podman-remote;
  };


}
