#!/usr/bin/env bash
set -eo pipefail

# Install (homebrew if it's not installed already)
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update && brew outdated && brew upgrade
fi


# install main packages
brew list git &>/dev/null || brew install git
brew list vim &>/dev/null || brew install vim
brew list cmake &>/dev/null || brew install cmake
brew list tmux &>/dev/null || brew install tmux
brew list stow &>/dev/null || brew install stow
brew list direnv &>/dev/null || brew install direnv
brew list python3 &>/dev/null || brew install python3
brew list python-setuptools &>/dev/null || brew install python-setuptools
brew list ctags &>/dev/null || brew install ctags
brew list autopep8 &>/dev/null || brew install autopep8
brew list flake8 &>/dev/null || brew install flake8

brew list flameshot &>/dev/null || brew install flameshot
brew list kitty &>/dev/null || brew install kitty

# setup NVM and LTS Node.js, optionally
if [[ "$*" == *"--nvm"* ]]; then
    if [[ ! -d "$HOME/.nvm" ]]; then
        export NVM_DIR="$HOME/.nvm" && (
          git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
          cd "$NVM_DIR"
          git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
        ) && \. "$NVM_DIR/nvm.sh"
    fi

    local_file="$HOME/.zshrc.local"
    if [[ ! -f "$local_file" ]]; then
        touch "$local_file"
    fi

    if ! grep -q 'nvm.sh' "$local_file"; then
        nvm_config_lines=(
            'export NVM_DIR="$HOME/.nvm"'
            '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
            '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'
        )
        for line in "${nvm_config_lines[@]}"; do
            echo "$line" | tee -a "$local_file" > /dev/null
        done
    fi

    export NVM_DIR=$HOME/.nvm
    source $NVM_DIR/nvm.sh
    nvm install --lts
fi
