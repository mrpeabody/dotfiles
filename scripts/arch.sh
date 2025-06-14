#!/usr/bin/env bash
set -eo pipefail


# install main packages
sudo pacman --needed --noconfirm -S less git cmake gcc ctags curl base-devel net-tools
sudo pacman --needed --noconfirm -S python-pip python-wheel python-setuptools
sudo pacman --needed --noconfirm -S python-flake8 autopep8
sudo pacman --needed --noconfirm -S tmux direnv


# only install GUI packages if not WSL and [--gui] flag is set
if { [ -f /proc/version ] && ! grep -qi Microsoft /proc/version; } && [[ "$*" == *"--gui"* ]]; then
    yes | sudo pacman --needed -S gvim || true
    sudo pacman --needed --noconfirm -S stow kitty mpv flameshot wl-clipboard
else
    yes | sudo pacman --needed -S vim || true
fi


# setup zsh, optionally
if [[ "$*" == *"--zsh"* ]]; then
    shell='zsh'
    sudo pacman --needed --noconfirm -S zsh
    chsh -s $(which zsh)
else
    shell='bash'
fi


# setup NVM and LTS Node.js, optionally
if [[ "$*" == *"--nvm"* ]]; then
    sudo pacman --needed --noconfirm -S nvm

    local_file="$HOME/.${shell}rc.local"
    if [[ ! -f "$local_file" ]]; then
        touch "$local_file"
    fi

    grep -q 'nvm.sh$' "$local_file" || echo "source /usr/share/nvm/init-nvm.sh" | tee -a "$local_file" > /dev/null
    source /usr/share/nvm/init-nvm.sh
    nvm install --lts
fi


# install and setup paru, if it's not yet installed
if ! command -v paru &> /dev/null; then
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg --needed --noconfirm -si 
    cd ..
    rm -rf paru-bin
    grep -q '^SkipReview' /etc/paru.conf || echo "SkipReview" | sudo tee -a /etc/paru.conf > /dev/null
fi
