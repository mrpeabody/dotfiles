#!/usr/bin/env bash
set -eo pipefail


# install main packages
sudo dnf makecache
sudo dnf -y install less tar curl vim-enhanced git cmake
sudo dnf -y install gcc-c++ net-tools
sudo dnf -y install vim-X11
sudo ln -sf /usr/bin/vimx /usr/local/bin/vim
sudo dnf -y install tmux

# not all RedHat clones are the same
RH_VERSION="$(cat /etc/os-release | grep 'REDHAT_SUPPORT_PRODUCT_VERSION=' \
    | cut -d '=' -f2 | cut -d '.' -f1 |  grep -Eo '[0-9]+')"

if [[ "$RH_VERSION" == "9" || "$RH_VERSION" == "10" ]]; then
    sudo dnf -y group install "Development Tools"
    sudo dnf -y install util-linux-user python3-pip python3-devel python3-setuptools*
    pip3 install --user flake8
    pip3 install --user autopep8
else
    sudo dnf -y group install "development-tools"
    sudo dnf -y install python3-pip python3-devel python3-setuptools python3-wheel
    sudo dnf -y install python3-flake8 python3-autopep8
    sudo dnf -y install stow kitty mpv direnv flameshot wl-clipboard
fi


# setup zsh, optionally
if [[ "$*" == *"--zsh"* ]]; then
    shell='zsh'
    sudo dnf -y install zsh
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
