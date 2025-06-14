#!/usr/bin/env bash
set -eo pipefail

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script installs packages, compatible with a wide variety of distros and OS. Oh-my-{bash,zsh} is included."
   echo
   echo "Syntax: ./install_packages.sh [-h|--help|--gui|--zsh|--nvm]"
   echo "options:"
   echo "[h | --help]     Print this Help."
   echo "--gui            Install and enable GUI apps, such as Kitty terminal, and MPV player."
   echo "--zsh            Install and enable ZSH as the shell."
   echo "--nvm            Install and enable NVM and LTS version of Node.js."
   echo
}
################################################################################


# Detect if a user wants a help message
if [[ "$1" == "--help"  || "$1" == "-h" ]]; then
    Help
    exit;
fi


# Base dir is where the script is located
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


# detect OS and use corresponding install script
echo "Installing OS-specific packages..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then      # Linux/WSL
    if [ -f "/etc/arch-release" ]; then       # Arch/Manjaro/CachyOS/EndeavorOS
        sh "$BASE_DIR/scripts/arch.sh" "$@"
    elif [ -f "/etc/redhat-release" ]; then   # Redhat 9+/Fedora/Nobara
        sh "$BASE_DIR/scripts/redhat.sh" "$@"
    else                                      # Ubuntu/Debian/Mint
        /bin/bash "$BASE_DIR/scripts/ubuntu.sh" "$@"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then       # MacOS
    sh "$BASE_DIR/scripts/macos.sh" "$@"
fi


# Install TMUX package manager
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo 'Cleaning up the old .tmux/plugins/tpm directory...'
    chmod -R 0755 "$HOME/.tmux/plugins/tpm"
    rm -rf "$HOME/.tmux/plugins/tpm"
fi

echo "Installing tmux package manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Detect if a user wants ZSH. For Macos, it's always ZSH
if [[ "$*" == *"--zsh"* || "$OSTYPE" == "darwin"* ]]; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo 'Cleaning up the old .oh-my-zsh directory...'
        chmod -R 0755 "$HOME/.oh-my-zsh"
        rm -rf "$HOME/.oh-my-zsh"
    fi

    echo "Installing oh-my-zsh..."
    KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    if [ -d "$HOME/.oh-my-bash" ]; then
        echo 'Cleaning up the old .oh-my-bash directory...'
        chmod -R 0755 "$HOME/.oh-my-bash"
        rm -rf "$HOME/.oh-my-bash"
    fi

    echo "Installing oh-my-bash..."
    git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash
fi


echo "Packages have been installed."
