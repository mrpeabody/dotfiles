#!/bin/bash
set -euo pipefail

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

echo "Stowing app configs..."
stow -t "$HOME/.config" -d "$BASE_DIR/config" --ignore="home" .

# Optional linux-only steps
if [[ "$platform" == "linux" ]]; then
    # Arch-based distros support flags files for chromium/electron-based applications
    if grep -qi "arch" /etc/os-release; then
        echo "Copying flags to ~/.config..."
        cp -f "$BASE_DIR/flags/"* "$HOME/.config/"
    fi

    mkdir -p "$HOME/.local/share/applications"
    echo "Copying launchers to ~/.local/share/applications..."
    cp -f "$BASE_DIR/launchers/"* "$HOME/.local/share/applications/"
fi

echo "Linking .bashrc..."
ln -sf "$BASE_DIR/config/home/.bashrc" "$HOME/.bashrc"

echo "Setting up tmux..."
ln -sf "$BASE_DIR/config/home/.tmux.conf" "$HOME/.tmux.conf"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server

echo "Done."
