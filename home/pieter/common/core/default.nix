{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  username = "pieter";
in {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bat
    ./gh
    ./git
    ./lesspipe
    ./languages/scala
    ./fzf
    ./starship
    ./yazi
    ./zsh
  ];

  home = {
    username = username;
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };

  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.my-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    devenv
    atac
    bottom
    bun
    cachix
    cabal-install
    chafa
    cht-sh
    cloudflared
    devbox
    dust
    fd
    file
    gcc
    gnumake
    grc
    glow
    gum
    hex
    keychain
    mediainfo
    nodejs
    nvd # nix visual diff
    procs
    ripgrep
    sd
    skaffold
    skate
    sqlite
    sops
    tailscale
    tree
    uv
    unzip
    xh
    zip
    age
    age-plugin-yubikey
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # This should source the nix.sh automatically
  targets.genericLinux.enable = !pkgs.stdenv.isDarwin;

  fonts.fontconfig.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".jq".text = ''
      def tocsv: (.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv;
    '';
  };

  home.shellAliases = {
    htop = "btm";
    hm = "home-manager";
    hmgd = ''
      home-manager generations | head -n 2 | tac | cut -d " " -f 7 | xargs nvd diff'';
    hmp = "home-manager packages";
    hms = "home-manager switch --flake ~/dotfiles#${username}@$(hostname) && hmgd";
    hmu = "nix flake update ~/dotfiles && hms";
    pvim = "${inputs.my-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/nvim";
  };

  # direnv and nix-direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # exa (ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = true;
    mutableTrust = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.graalvmPackages.graalvm-ce;
  };

  programs.jq = {enable = true;};

  programs.keychain = {
    enable = true;
    enableZshIntegration = false;
    enableXsessionIntegration = false;
    keys = ["~/.ssh/github"];
  };

  programs.zsh.initContent = lib.mkOrder 600 ''
    # In SSH sessions, keep forwarded Windows/YubiKey agents as-is.
    # Running keychain here can select a cached local agent instead.
    if [[ ! -S "$SSH_AUTH_SOCK" || ( -z "$SSH_CONNECTION" && -z "$SSH_TTY" ) ]]; then
      eval "$(SHELL=zsh ${pkgs.keychain}/bin/keychain --eval --quiet ~/.ssh/github)"
    fi
  '';

  programs.nushell = {enable = true;};

  programs.pet = {
    enable = true;
    snippets = [
      {
        command = "git rev-list --count HEAD";
        description = "Count the number of commits in the current branch";
        output = "473";
      }
    ];
  };

  programs.tealdeer = {
    enable = true;
    settings = {display = {compact = true;};};
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.home-manager.autoExpire = {
    enable = true;
    frequency = "daily";
    timestamp = "-3 days";
  };

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    enable = true;
    autoEnable = true;
  };
}
