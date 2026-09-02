{pkgs, ...}: {
  # Needed for determinate systems install
  nix.enable = false;

  launchd.daemons.nix-gc = {
    command = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 7d";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
    };
  };

  environment.systemPackages = [pkgs.vim];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "openssh"
      "yubico-piv-tool"
      "kanata"
    ];
    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
    ];
    casks = [
      "aerospace"
      "keepassxc"
      "raycast"
      "syncthing-app"
      "google-drive"
      "visual-studio-code"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  system.primaryUser = "pieter";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
