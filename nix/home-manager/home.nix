{ config, pkgs, ... }:

{
  home.username = "pieter";
  home.homeDirectory = "/home/pieter";

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    bottom
    cht-sh
    chafa
    coursier
    du-dust
    fd
    gcc
    gitui
    grc
    gum
    hex
    keychain
    lazygit
    mediainfo
    neovim
    procs
    ranger
    ripgrep
    ripgrep-all
    scala-cli
    sd
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
  };
  
  xdg.configFile.lvim = {
    source = ./config/lvim;
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "lvim";
  };
  home.shellAliases = {
    cd = "z";
    htop = "btm";
    cat = "bat --color=always";
    hm = "home-manager";
    hmd = "cd ~/dotfiles/nix/home-manager";
    hmgd = "home-manager generations | head -n 2 | tac | cut -d \" \" -f 7 | xargs nix store diff-closures";
    hmp = "home-manager packages";
    hms = "home-manager switch --flake ~/dotfiles/nix/home-manager#pieter && hmgd";
    hmu = "nix flake update ~/dotfiles/nix/home-manager && hms";
    hmhe = "nvim ~/dotfiles/nix/home-manager/home.nix";
  };
  
  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  # direnv and nix-direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };


  # exa (ls replacement)
  programs.exa = {
    enable = true;
    enableAliases = true;
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
    package = pkgs.graalvm17-ce;
  };

  programs.jq = {
    enable = true;
  }

  # TODO: add keychain

  # Needed for fzf-pipe content rendering
  programs.lesspipe.enable = true;

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
    keyScheme = "vim";
  };

  # navi (a cli cheat sheet)
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  # TODO: consider nushell
  # TODO: consider pet
  # TODO: add pistol. A previewer for ranger

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
    settings = {
      scala.disabled = true;
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
    initExtra = ''

    # allow v to open current line in editor when in cmd mode
    autoload edit-command-line; zle -N edit-command-line
    bindkey -M vicmd v edit-command-line

    # use tab to accept suggestion
    zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
    # # REVIEW THIS: for colors
    zstyle ':completion:*:descriptions' format '[%d]'
    # Preview window size
    zstyle ':fzf-tab:*' fzf-min-height 50
    # Help for commands
    zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out)' 
    zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ''${(Q)realpath}'

    # Colored man pages
    export LESS_TERMCAP_mb=$'\e[1;32m'
    export LESS_TERMCAP_md=$'\e[1;32m'
    export LESS_TERMCAP_me=$'\e[0m'
    export LESS_TERMCAP_se=$'\e[0m'
    export LESS_TERMCAP_so=$'\e[01;33m'
    export LESS_TERMCAP_ue=$'\e[0m'
    export LESS_TERMCAP_us=$'\e[1;4;31m'
    # Make less work nicely with bat
    export LESS=-R
    '';
    shellAliases = {
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "Aloxaf/fzf-tab"; }
        # TODO: This breaks command completion help. The file -command-.zsh is causing this
        # { name = "Freed-Wu/fzf-tab-source"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
