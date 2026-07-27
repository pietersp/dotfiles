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
    # ./common/optional/ides/intellij
    # ./common/optional/ides/vscode
    ./common/optional/wezterm
  ];

  # This is needed because darwin installed podman but it is not present on the path.
  # Might be a better way to do this
  home.sessionPath = ["/opt/podman/bin"];

  home.packages = with pkgs; [
    # Avoid mpv-with-scripts here because yt-dlp now pulls in deno.
    mpv-unwrapped
    python3
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.check-cli-versions
  ];

  languages.scala.enable = true;

  programs.zsh.shellAliases = {
    docker = "podman";
  };

  # The tldr cache updater is a background service and must also work when
  # Home Manager is activated without an active Aqua session (for example,
  # over SSH).
  launchd.agents.tldr-update.domain = "user";

  # Home Manager's generated option docs currently embed a Nixpkgs source path
  # without store context, which makes its options.json derivation unreliable.
  manual.manpages.enable = false;

  # Set a target for home-manager to link to
  # home = {
  # username = "pieter";
  #  homeDirectory = "/Users/pieter";
  #  stateVersion = "23.05"; # Please read the comment before changing.
  # };
}
