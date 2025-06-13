#!/usr/bin/env bash
set -eo pipefail

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script links configuration files from this repo to proper locations in the home directory."
   echo "Run the scripts/install_packages.sh script first."
   echo
   echo "Syntax: ./link_configs.sh [-h|--help|--zsh]"
   echo "options:"
   echo "[h | --help]     Print this Help."
   echo "--zsh            Link ZSH configuration files instead of BASH."
   echo
}
################################################################################


# Detect if a user wants a help message
if [[ "$1" == "--help"  || "$1" == "-h" ]]; then
    Help
    exit;
fi


# detect OS
OS="$(uname)"
case "$OS" in
    Darwin) platform="macos" ;;
    Linux) platform="linux" ;;
    *) platform="unknown" ;;
esac


# Base dir is where the script is located
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$HOME/.config"

if command -v stow &> /dev/null; then
    echo "Stowing app configs..."
    stow -t "$HOME/.config" -d "$BASE_DIR/config" --ignore="home" .
fi


# Optional linux-only steps
if [[ "$platform" == "linux" ]]; then
    # Arch-based distros support flags files for chromium/electron-based applications
    if grep -qi "arch" /etc/os-release; then
        echo "Linking flags to ~/.config..."
        ln -sf "$BASE_DIR/flags/"* "$HOME/.config/"
    fi

    echo "Linking launchers to ~/.local/share/applications..."
    mkdir -p "$HOME/.local/share/applications"
    ln -sf "$BASE_DIR/launchers/"* "$HOME/.local/share/applications/"
fi

if [[ "$*" == *"--zsh"* ]]; then
    echo "Linking .zshrc..."
    ln -sf "$BASE_DIR/config/home/.zshrc" "$HOME/.zshrc"
else
    echo "Linking .bashrc..."
    ln -sf "$BASE_DIR/config/home/.bashrc" "$HOME/.bashrc"
fi


echo "Linking tmux config..."
ln -sf "$BASE_DIR/config/home/.tmux.conf" "$HOME/.tmux.conf"
tmux start-server
tmux new-session -d
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server


echo "Configuration files have been linked."
