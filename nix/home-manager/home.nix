{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pieter";
  home.homeDirectory = "/home/pieter";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bottom
    cht-sh
    coursier
    du-dust
    fd
    git
    graalvm17-ce
    gum
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

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pieter/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
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
    defaultCommand = "fd --type f --color=never --hidden";
    defaultOptions = [
      "--no-height" 
      "--color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b"
    ];
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };
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

  # zoxide (smart cd alternative)
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
    initExtra = "
    # Put lvim on the path
    export PATH=$PATH:$HOME/.local/bin
    ";
    shellAliases = {
      htop = "btm";
      cd = "z";
    };

    zplug = {
      enable = true;
      plugins = [
        # { name = "zsh-users/zsh-autosuggestions"; } 
        { name = "marlonrichert/zsh-autocomplete"; }
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
