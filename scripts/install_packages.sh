#!/usr/bin/env bash
set -euo pipefail

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script installs packages, compatible with a wide variety of distros and OS. Oh-my-{bash,zsh} is included."
   echo
   echo "Syntax: ./install_packages.sh [-h|--help|--zsh|--nvm]"
   echo "options:"
   echo "[h | --help]     Print this Help."
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


# detect OS
echo "Installing OS-specific packages..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then      # Linux/WSL
    if [ -f "/etc/arch-release" ]; then       # Arch/Manjaro/CachyOS/EndeavorOS
        sh "$BASE_DIR/arch.sh" "$@"
    elif [ -f "/etc/redhat-release" ]; then   # Redhat 9+/Fedora/Nobara
        sh "$BASE_DIR/redhat.sh" "$@"
    else                                      # Ubuntu/Debian/Mint
        sh "$BASE_DIR/ubuntu.sh" "$@"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then       # MacOS
    sh "$BASE_DIR/macos.sh" "$@"
fi


# Detect if a user wants ZSH. For Macos, it's always ZSH
if [[ "$*" == *"--zsh"* || "$OSTYPE" == "darwin"* ]]; then
    echo "Installing oh-my-zsh..."
    KEEP_ZSHRC=yes RUNZSH=no CHSH=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Installing oh-my-bash..."
    git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash
fi


echo "Installing tmux package manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


echo "Packages have been installed. Please reboot to apply all the changes."
