{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Needed for determinate systems install
  nix.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    wezterm
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [];
    taps = [
      "nikitabobko/tap"

    ];
    casks = [
      "aerospace"
      "keepassxc"
      "raycast"
      "syncthing-app"
      "google-drive"
      "visual-studio-code"
      "podman-desktop"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # Use our custom packages
  #nixpkgs.overlays = [outputs.overlays.additions outputs.overlays.modifications outputs.overlays.unstable];

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "pieter";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
