{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  catppuccinObsidianTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "catppuccin-obsidian";
    version = "0.4.47";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "obsidian";
      rev = "55aa9c9036a9df864593fdaedb2a227d3823fb06";
      sha256 = "0lanq9wpkxsp8554lx5a11l2z7c7imy62hcwxggp344rfkd1l7dq";
    };

    installPhase = ''
      runHook preInstall
      install -Dm644 manifest.json "$out/manifest.json"
      install -Dm644 theme.css "$out/theme.css"
      runHook postInstall
    '';
  };
in {
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
    zed-editor
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.codex-cli
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.check-cli-versions
  ];

  programs.obsidian = {
    enable = true;
    cli.enable = true;
    defaultSettings.themes = [catppuccinObsidianTheme];

    vaults.Vault = {
      target = "Documents/Vaults/Vault";
    };
  };

  home.file."Documents/Vaults/Vault/.obsidian/appearance.json".force = true;

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
