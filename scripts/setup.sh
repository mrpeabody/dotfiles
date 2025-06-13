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
   echo "Syntax: ./setup.sh [-h|--help|--zsh|--nvm]"
   echo "options:"
   echo "[h | --help]     Print this Help."
   echo "--zsh            Install, enable, and configure ZSH as the shell."
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


# Install and link
sh "$BASE_DIR/scripts/install.sh" "$@"
sh "$BASE_DIR/scripts/link.sh" "$@"


# All done
if [[ ! "$OSTYPE" == "darwin"* ]]; then
    echo "Please reboot or logout/login to the system to apply all the changes."
fi
