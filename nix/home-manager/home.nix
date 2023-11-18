{ config, pkgs, ... }:

let
  lunarvim = pkgs.lunarvim.overrideAttrs (
  old: {
    src = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "LunarVim";
      rev = "f74046d1911e430ca734d1ed1509d2ff3bdfe7e1";
      sha256 = "z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
    };
  });
in
{
  home.username = "pieter";
  home.homeDirectory = "/home/pieter";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    bottom
    chafa
    cht-sh
    coursier
    du-dust
    fd
    gcc
    gitui
    gnumake
    grc
    gum
    hex
    jsonnet
    keychain
    lazygit
    lunarvim
    mediainfo
    neovim
    nodejs
    procs
    ranger
    ripgrep
#    ripgrep-all
    scala-cli
    sd
    sqlite
    stow
    tree
    unzip
    xh
    zip
    zellij
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
  };
  
  xdg.configFile.lvim = {
    source = ./config/lvim;
    recursive = true;
  };

  xdg.configFile.wezterm = {
    source = ./config/wezterm;
    recursive = true;
  };

  xdg.configFile.zellij = {
    source = ./config/zellij;
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "lvim";
  };
  home.shellAliases = {
    htop = "btm";
    hm = "home-manager";
    hmgd = "home-manager generations | head -n 2 | tac | cut -d \" \" -f 7 | xargs nix store diff-closures";
    hmp = "home-manager packages";
    hms = "home-manager switch --flake ~/dotfiles/nix/home-manager#pieter && hmgd";
    hmu = "nix flake update ~/dotfiles/nix/home-manager && hms";
    hmhe = "lvim ~/dotfiles/nix/home-manager/home.nix";
  };
  
  programs.bat = {
    enable = true;
    themes = {
      catppuccin = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat"; # Bat uses sublime syntax for its themes
        rev = "477622171ec0529505b0ca3cada68fc9433648c6";
        sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
      };
      file = "Catppuccin-mocha.tmTheme";
      };
    };
    config.theme = "catppuccin";
  };

  programs.carapace = {
    enable = false;
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
    enableAliases = false;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    colors = {
      hl    = "#c678dd";
      "fg+" = "#ffffff";
      "bg+" = "#4b5263";
      "hl+" = "#d858fe";
      info  = "#98c379";
      prompt = "#61afef";
      pointer = "#be5046";
      marker  = "#e5c07b";
      spinner = "#61afef";
      header = "#61afef"; 
    };
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };

  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };
    userEmail = "pietersp@gmail.com";
    userName = "Pieter Prinsloo";
  };

  programs.java = {
    enable = true;
    package = pkgs.graalvm-ce;
  };

  programs.jq = {
    enable = true;
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["~/.ssh/github"];

  };

  # Needed for fzf-pipe content rendering
  programs.lesspipe.enable = true;

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
    keyScheme = "vim";
  };

  programs.nushell = {
    enable = true;
  };

  programs.pistol = {
    enable = true;
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
    settings ={
      display = {
        compact = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # zsh and plugins
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.stateHome}/zsh/zsh_history";
    };

    plugins = [
      { 
        name = "fzf-tab"; 
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions"; 
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    initExtra = ''

    # allow v to open current line in editor when in cmd mode
    autoload edit-command-line; zle -N edit-command-line
    bindkey -M vicmd v edit-command-line

    # use tab to accept suggestion
    zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
    # needed for $group variable 
    zstyle ':completion:*:descriptions' format '[%d]'
    # Preview window size
    zstyle ':fzf-tab:*' fzf-min-height 50
    # Help for commands
    zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out)' 
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ''${(Q)realpath}'
    '';

    sessionVariables = {
      LANG = "en_US.UTF-8";
      LESS = "-r";
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      llt = "eza -la --sort newest";
      cd = "z";
    };

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
