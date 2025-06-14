#!/bin/bash
set -eo pipefail


# install main packages
sudo apt -y update
sudo apt -y install curl git build-essential cmake net-tools
sudo apt -y install vim-gtk3 wl-clipboard tmux stow direnv
sudo apt -y install python-is-python3 python-dev-is-python3 python3-setuptools python3-pip python3-wheel
sudo apt -y install flake8 python3-flake8 python3-autopep8
sudo apt -y install fonts-powerline
sudo apt -y install kitty mpv flameshot


# setup zsh, optionally
if [[ "$*" == *"--zsh"* ]]; then
    shell='zsh'
    sudo apt -y install zsh
    chsh -s $(which zsh)
else
    shell='bash'
fi


# setup NVM and LTS Node.js, optionally
if [[ "$*" == *"--nvm"* ]]; then
    if [[ ! -d "$HOME/.nvm" ]]; then
        export NVM_DIR="$HOME/.nvm" && (
          git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
          cd "$NVM_DIR"
          git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
        ) && \. "$NVM_DIR/nvm.sh"
    fi

    local_file="$HOME/.${shell}rc.local"
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
