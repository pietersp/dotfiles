{ config, pkgs, ... }:

let
  username = "pieter";
  lunarvim = pkgs.lunarvim.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "LunarVim";
      rev = "f74046d1911e430ca734d1ed1509d2ff3bdfe7e1";
      sha256 = "z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
    };
  });
in {
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    bottom
    chafa
    cht-sh
    csvkit
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
    lunarvim
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

  home.sessionPath = [ "$HOME/.local/bin" ];

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

  xdg.configFile.lvim = {
    source = ./config/lvim;
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

  home.sessionVariables = { EDITOR = "lvim"; };
  home.shellAliases = {
    htop = "btm";
    hm = "home-manager";
    hmgd = ''
      home-manager generations | head -n 2 | tac | cut -d " " -f 7 | xargs nix store diff-closures'';
    hmp = "home-manager packages";
    hms =
      "home-manager switch --flake ~/dotfiles/nix/home-manager#${username} && hmgd";
    hmu = "nix flake update ~/dotfiles/nix/home-manager && hms";
    hmhe = "lvim ~/dotfiles/nix/home-manager/home.nix";
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

  programs.carapace = { enable = false; };

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
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -50'" ];
  };

  programs.git = {
    enable = true;
    delta = { enable = true; };
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

  programs.jq = { enable = true; };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [ "~/.ssh/github" ];

  };

  # Needed for fzf-pipe content rendering
  programs.lesspipe.enable = true;

  programs.mcfly = {
    enable = true;
    enableZshIntegration = true;
    keyScheme = "vim";
  };

  programs.nushell = { enable = true; };

  programs.pet = {
    enable = true;
    snippets = [{
      command = "git rev-list --count HEAD";
      description = "Count the number of commits in the current branch";
      output = "473";
    }];
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
    settings = { display = { compact = true; }; };
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
    settings = { theme = "catppuccin-mocha"; };
  };

  # zsh and plugins
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    history = { path = "${config.xdg.stateHome}/zsh/zsh_history"; };

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
      {
        name = " jq-zsh-plugin ";
        src = pkgs.fetchFromGitHub {
          owner = "reegnz";
          repo = "jq-zsh-plugin";
          rev = "a5b404a8de5c0ef426f9bb4acbb31778862e2b18";
          sha256 = "gyVK1u5FgzN9zqkR/H3mGe8qlIY1By2S9PsmSgtH87U=";
        };
        file = "jq.plugin.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
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
      # git commands
      zstyle ':completion:*:git-(checkout|log|show):*' sort false
      zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
        'git diff $word | delta'
      zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
        'git log --color=always $word'
      zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
        'git help $word | bat -plman --color=always'
      zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
        'case "$group" in
        "commit tag") git show --color=always $word ;;
        *) git show --color=always $word | delta ;;
        esac'
      zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
        'case "$group" in
        "[modified file]") git diff $word | delta ;;
        "[recent commit object name]") git show --color=always $word | delta ;;
        *) git log --color=always $word ;;
        esac'
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
