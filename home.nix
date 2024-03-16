{
  inputs,
  config,
  pkgs,
  devenv,
  ...
}: let
  username = "pieter";
in {
  imports = [
    ./programs/zsh/zsh.nix
    ./programs/lunarvim/lunarvim.nix
  ];

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    devenv.packages."${pkgs.system}".devenv
    bottom
    cachix
    chafa
    cht-sh
    # csvkit
    du-dust
    fd
    gcc
    gitui
    git-crypt
    gnumake
    grc
    glow
    gum
    hex
    jsonnet
    keychain
    lazygit
    mediainfo
    mods
    neovim
    nodejs
    procs
    ripgrep
    #    ripgrep-all
    sd
    skaffold
    skate
    sqlite
    stow
    tree
    unzip
    xh
    zip
  ];

  # This should source the nix.sh automatically
  targets.genericLinux.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".lessfilter".source = ./config/.lessfilter;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".jq".text = ''
      def tocsv: (.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv;
    '';
  };

  xdg.configFile.delta = {
    source = ./config/delta;
    recursive = true;
  };

  xdg.configFile.gitui = {
    source = ./config/gitui;
    recursive = true;
  };

  xdg.configFile.wezterm = {
    source = ./config/wezterm;
    recursive = true;
  };

  xdg.configFile.yazi = {
    source = ./config/yazi;
    recursive = true;
  };

  home.shellAliases = {
    htop = "btm";
    hm = "home-manager";
    hmgd = ''
      home-manager generations | head -n 2 | tac | cut -d " " -f 7 | xargs nix store diff-closures'';
    hmp = "home-manager packages";
    hms = "home-manager switch --flake ~/dotfiles#${username} && hmgd";
    hmu = "nix flake update ~/dotfiles && hms";
    hmhe = "lvim ~/dotfiles/home.nix";
  };

  programs.bat = {
    enable = true;
    themes = {
      Catppuccin-mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat"; # Bat uses sublime syntax for its themes
          rev = "477622171ec0529505b0ca3cada68fc9433648c6";
          sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
    config.theme = "Catppuccin-mocha";
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      hl = "#c678dd";
      "fg+" = "#ffffff";
      "bg+" = "#4b5263";
      "hl+" = "#d858fe";
      info = "#98c379";
      prompt = "#61afef";
      pointer = "#be5046";
      marker = "#e5c07b";
      spinner = "#61afef";
      header = "#61afef";
    };
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };

  programs.git = {
    enable = true;
    delta = {enable = true;};
    userEmail = "pietersp@gmail.com";
    userName = "Pieter Prinsloo";
    extraConfig = {
      include.path = "~/.config/delta/themes.gitconfig";
      delta.features = "catppuccin";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = true;
    mutableTrust = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.graalvm-ce;
  };

  programs.jq = {enable = true;};

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["~/.ssh/github"];
  };

  # Needed for fzf-pipe content rendering
  programs.lesspipe.enable = true;

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

  # job management
  services.pueue = {
    enable = true;
    settings = {
      shared = {
        use_unix_socket = true;
        host = "127.0.0.1";
        port = "6924";
      };
    };
  };

  # starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      scala.disabled = true;
      container.disabled = true;
    };
  };

  programs.tealdeer = {
    enable = true;
    settings = {display = {compact = true;};};
  };

  # file manager
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {theme = "catppuccin-mocha";};
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
