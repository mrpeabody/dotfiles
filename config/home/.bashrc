# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac


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


# default binds for bash
bind 'set editing-mode vi'
bind 'set keyseq-timeout 0'
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line


# universal open function
function open () {
  xdg-open "$@">/dev/null 2>&1
}


# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"

OSH_THEME="agnoster"
# OSH_THEME="nekonight"
# OSH_THEME="powerbash10k"
# OSH_THEME="font"  # default for oh-my-bash
# OSH_THEME="robbyrussell" # default for oh-my-zsh

DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
OMB_USE_SUDO="true"
OMB_PROMPT_SHOW_PYTHON_VENV="true"  # enable

completions=(
  git
  composer
  ssh
)

aliases=(
  general
)

plugins=(
  git
  bashmarks
)

source "$OSH"/oh-my-bash.sh


# oh-my-bash post-hook settings
function prompt_hg { return 0; } # disable mercurial support in agnoster
export PROMPT_DIRTRIM=0 # prevent trimming path
shopt -s globstar
set +o noclobber


# Source local per-machine customizations, if present
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi
