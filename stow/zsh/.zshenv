# XDG specifications
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Start up zsh using the XDG config location
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ZSH History settings
export HISTFILE="$XDG_STATE_HOME/.zhistory"
export HISTSIZE=10000 
export SAVEHIST=10000

