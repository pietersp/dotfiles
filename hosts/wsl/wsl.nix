{
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "nixos";
  time.timeZone = "Africa/Johannesburg";

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  users.users.pieter = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = [
    (import ./win32yank.nix {inherit pkgs;})
    pkgs.git
    pkgs.wget
  ];

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
      trusted-users = ["pieter"];
      accept-flake-config = true;
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
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
