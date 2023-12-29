{
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "nixos";
  time.timeZone = "Africa/Johannesburg";

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  users.users.pieter = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "23.05";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "pieter";
    startMenuLaunchers = true;
  };

  nix = {
    settings = {
      trusted-users = [ "pieter" ];
      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';
  };
}
