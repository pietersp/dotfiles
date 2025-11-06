{
  inputs,
  config,
  pkgs,
  ...
}: let
  username = "pieter";
in {
  imports = [
    ./bat
    ./git
    ./lesspipe
    ./fzf
    ./starship
    ./yazi
    ./zsh
  ];

  home = {
    username = "${username}";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
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
    # csvkit
    dust
    erlang
    fd
    file
    gcc
    gemini-cli
    # gleam
    # ghc
    # haskell-language-server
    gnumake
    grc
    glow
    gum
    hex
    #jsonnet # disabled due to compilation failure 20251008
    keychain
    mediainfo
    # mods
    # neovim
    nodejs
    nvd # nix visual diff
    procs
    ripgrep
    #    ripgrep-all
    sd
    skaffold
    skate
    sqlite
    # stow
    # superfile 2025-08-03 Broken
    tailscale
    tree
    unzip
    xh
    zip
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # This should source the nix.sh automatically
  targets.genericLinux.enable =
    if pkgs.stdenv.isDarwin
    then false
    else true;

  fonts.fontconfig.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];

  home.sessionVariables = {
    EDITOR = "nvim";
    # "ZELLIJ_AUTO_ATTACH" = "true";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  programs.carapace = {enable = false;};

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
    enableZshIntegration = true;
    keys = ["~/.ssh/github"];
  };

  programs.mcfly = {
    enable = false;
    enableZshIntegration = true;
    keyScheme = "vim";
  };

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

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {show_startup_tips = false;};
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";
    enable = true;
  };
}
