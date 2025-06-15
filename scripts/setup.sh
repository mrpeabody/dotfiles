#!/usr/bin/env bash
set -eo pipefail

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script installs packages and configures environment. See README.md for more details."
   echo
   echo "Syntax: ./setup.sh [-h|--help|--zsh|--nvm|--fonts|--vim[=<go,csharp,java,go,rust>]]"
   echo "options:"
   echo "[h | --help]                      Print this Help."
   echo "--zsh                             Install, enable, and configure ZSH as the shell."
   echo "--nvm                             Install and enable NVM and LTS version of Node.js."
   echo "--fonts                           install, and configure terminal/VIM fonts."
   echo "--vim[=<go,csharp,java,rust>]     Install and setup VIM. Specify optional language support (comma-delimited)."
   echo "                                       Available options: go, csharp, java, and rust."
   echo "                                                 Example: --vim"
   echo "                                                 Example: --vim=go,java"
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


# Install and link
bash "$BASE_DIR/scripts/install.sh" "$@"
bash "$BASE_DIR/scripts/link.sh" "$@"


# Optionally install fonts
if [[ "$*" == *"--fonts"* ]]; then
    bash "$BASE_DIR/scripts/fonts.sh"
fi


# Optionally run vim_setup installation
if [[ "$*" == *"--vim"* ]]; then
    bash "$BASE_DIR/scripts/vim.sh" "$@"
fi


# All done
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Please restart your terminal to apply all the changes."
else
    echo "Please reboot or logout/login to the system to apply all the changes."
fi
