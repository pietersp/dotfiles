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
    git
    graalvm17-ce
    gum
    hex
    keychain
    lazygit
    neovim
    procs
    ranger
    ripgrep
    ripgrep-all
    scala-cli
    sd
    stow
    tealdeer
    tree
    unzip
    xh
    zip
  ];

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
    EDITOR = "nvim";
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
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };

  programs.lesspipe.enable = true;

  # navi (a cli cheat sheet)
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
  };

  # starship prompt
  programs.starship = {
    enable = true;
    settings = {
      scala.disabled = true;
    };
  };

  # zsh and plugins
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.stateHome}/zsh/zsh_history";
    };
    initExtra = ''
    # Put lvim on the path
    export PATH=$PATH:$HOME/.local/bin

    # use tab to accept suggestion
    zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
    # # REVIEW THIS: for colors
    zstyle ':completion:*:descriptions' format '[%d]'
    # Preview window size
    zstyle ':fzf-tab:*' fzf-min-height 50
    # Help for commands
    zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out)' 
    zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
    '';
    shellAliases = {
      htop = "btm";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "Aloxaf/fzf-tab"; }
        # TODO: This breaks command completion help. The file -command-.zsh is causing this
        { name = "Freed-Wu/fzf-tab-source"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
