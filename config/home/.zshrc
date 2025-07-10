# settings
export DEFAULT_USER=$USER
export EDITOR=vim
export VISUAL=vim
export GREP_OPTIONS='--color=always'


# better MAN support
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


# universal open function
function open() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command open "$@" >/dev/null 2>&1
  else
    xdg-open "$@" >/dev/null 2>&1
  fi
}


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
# OSH_THEME="robbyrussell" # default for oh-my-zsh
# OSH_THEME="nekonight"
# OSH_THEME="powerlevel10k"

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(git vi-mode direnv)

source $ZSH/oh-my-zsh.sh


# oh-my-zsh post-hook settings
unsetopt noclobber
alias scp='noglob scp'
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY


# Source local per-machine customizations, if present
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
