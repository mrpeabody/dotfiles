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
   echo "Syntax: ./link.sh [-h|--help|--gui|--zsh]"
   echo "options:"
   echo "[h | --help]     Print this Help."
   echo "--gui            Link GUI apps' configuration files, such as Kitty terminal, and MPV player."
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


# a few mac-specific things
if [[ "$OSTYPE" == "darwin"* ]]; then
    # we might need to eval homebrew for fresh MacOS installations
    # otherwise it might not be in the PATH yet
    if ! command -v brew &> /dev/null; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # MPV on mac doesn't work well, and flameshot settings are incompatible
    ignore_list='home|mpv|flameshot'
else
    ignore_list='home'
fi


# Base dir is where the script is located
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


# preparing the config directory
mkdir -p "$HOME/.config"


if [[ "$*" == *"--gui"* ]] && command -v stow &> /dev/null; then
    echo "Verifying app config directories can be symlinked using stow..."
    stow -nv -t "$HOME/.config" -d "$BASE_DIR/config" --ignore="$ignore_list" .

    echo "Stowing app config directories..."
    stow -t "$HOME/.config" -d "$BASE_DIR/config" --ignore="$ignore_list" .
fi


# Optional linux-only steps: require [--gui] flag
if [[ "$*" == *"--gui"* && "$platform" == "linux" ]]; then
    # Arch-based distros support flags files for chromium/electron-based applications
    if grep -qi "arch" /etc/os-release; then
        echo "Linking flags to ~/.config..."
        for src in "$BASE_DIR/flags/"*; do
            dst="$HOME/.config/$(basename "$src")"

            if [ -e "$dst" ] && [ ! -L "$dst" ]; then
                echo "$dst already exists, moving to ${dst}.bak"
                mv "$dst" "$dst.bak.$(date +%s)"
            fi

            ln -sf "$src" "$dst"
        done
        echo "Symlinked $HOME/.config/*.flags.conf -> $BASE_DIR/flags/*"
    fi


    # Linking launchers
    launchers="$HOME/.local/share/applications"

    # for Kitty, we need to dynamically generate a launcher before linking
    kitty_file="$BASE_DIR/launchers/kitty.desktop"
    mkdir -p "$(dirname "$desktop_file")"
    cat > "$kitty_file" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=kitty
GenericName=Terminal emulator
Comment=Fast, feature-rich, GPU based terminal
TryExec=kitty
StartupNotify=true
Exec=kitty -e
Icon=${HOME}/.config/kitty/kitty.app.png
Categories=System;TerminalEmulator;
X-TerminalArgExec=--
X-TerminalArgTitle=--title
X-TerminalArgAppId=--class
X-TerminalArgDir=--working-directory
X-TerminalArgHold=--hold

[Desktop Action New]
Name=kitty
Exec=kitty
EOF

    echo "Linking launchers to $launchers..."
    mkdir -p "$launchers"
    for src in "$BASE_DIR/launchers/"*; do
        dst="$launchers/$(basename "$src")"

        if [ -e "$dst" ] && [ ! -L "$dst" ]; then
            echo "$dst already exists, moving to ${dst}.bak"
            mv "$dst" "$dst.bak.$(date +%s)"
        fi

        ln -sf "$src" "$dst"
    done
    echo "Symlinked $launchers/* -> $BASE_DIR/launchers/*"
fi


# Detect shell and link the corresponding config file
if [[ "$*" == *"--zsh"* || "$OSTYPE" == "darwin"* ]]; then
    shell='zsh'
else
    shell='bash'
fi

echo "Linking .${shell}rc..."
rc_path="$HOME/.${shell}rc"
if [ -e "$rc_path" ] && [ ! -L "$rc_path" ]; then
    echo "$rc_path already exists, moving to ~/.${shell}rc.bak"
    mv "$rc_path" "$rc_path.bak.$(date +%s)"
fi

ln -sf "$BASE_DIR/config/home/.${shell}rc" "$rc_path"
echo "Symlinked $rc_path -> $BASE_DIR/config/home/.${shell}rc"


echo "Linking tmux config..."
tmux_path="$HOME/.tmux.conf"
if [ -e "$tmux_path" ] && [ ! -L "$tmux_path" ]; then
    echo "$tmux_path already exists, moving to ~/.tmux.conf.bak"
    mv "$tmux_path" "$tmux_path.bak.$(date +%s)"
fi

ln -sf "$BASE_DIR/config/home/.tmux.conf" "$tmux_path"
echo "Symlinked $tmux_path -> $BASE_DIR/config/home/.tmux.conf"

if command -v tmux &> /dev/null; then
    echo "Applying the linked tmux config..."
    tmux start-server
    tmux new-session -d
    $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
    tmux kill-server
fi


echo "Configuration files have been linked"
