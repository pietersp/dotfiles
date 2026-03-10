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
  ];
  # Try override for wsl
  programs.zellij.enable = lib.mkForce false;
}
