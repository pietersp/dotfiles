{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    coreutils
    curl
    gnumake
    gnused
    gnutar
    unzip
    vim
    wget
    zsh
  ];

  # Use our custom packages
  nixpkgs.overlays = [outputs.overlays.additions outputs.overlays.modifications outputs.overlays.unstable];

  # Set DNS servers.
  networking.dns = ["1.1.1.1" "1.0.0.1"];

  # Set the system shell.
  users.defaultUserShell = pkgs.zsh;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;  # Not recommended to use this along with fish.

  # https://github.com/LnL7/nix-darwin/issues/29
  # security.pam.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Link home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pieter = import ../../home/pieter/tethys.nix;
    extraSpecialArgs = {inherit inputs outputs;};
  };
}
