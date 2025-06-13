#!/usr/bin/env bash
set -eo pipefail


# install main packages
sudo pacman --needed --noconfirm -S git cmake gcc ctags curl base-devel
sudo pacman --needed --noconfirm -S python-pip python-wheel python-setuptools
sudo pacman --needed --noconfirm -S python-flake8 autopep8
sudo pacman --needed --noconfirm -S wl-clipboard net-tools
yes | sudo pacman --needed -S gvim
sudo pacman --needed --noconfirm -S stow kitty mpv tmux direnv flameshot


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
if [ ! -f "/usr/bin/paru" ]; then
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg --needed --noconfirm -si 
    cd ..
    rm -rf paru-bin
    grep -q '^SkipReview' /etc/paru.conf || echo "SkipReview" | sudo tee -a /etc/paru.conf > /dev/null
fi
