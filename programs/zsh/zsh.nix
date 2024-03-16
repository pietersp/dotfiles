{ config
, pkgs
, ...
}: {
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
}
