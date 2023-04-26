
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

if [ -f "$HOME/.bash_aliases" ] ; then
  source "$HOME/.bash_aliases"
fi


if [ $(command -v fzf) ]; then
  export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
  export FZF_DEFAULT_OPTS='--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

  export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
fi



if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
fi

# if fzf is installed via nix
if [ $(command -v fzf-share) ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

if [ $(command -v direnv) ]; then
  export DIRENV_LOG_FORMAT=
  eval "$(direnv hook zsh)"
fi

if [ $(command -v starship) ]; then
  eval "$(starship init zsh)"
fi

if [ $(command -v zoxide) ]; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

if [ $(command -v exa) ]; then
  alias ls='exa'
fi


# source local settings in addition to all the above
if [ -f "$HOME/.local/.zshrc" ] ; then
  source "$HOME/.local/.zshrc"
fi

if [ -f "$HOME/.local/.bash_aliases" ] ; then
  source "$HOME/.local/.bash_aliases"
fi

# activate vi mode
bindkey -v

