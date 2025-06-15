#!/usr/bin/env bash
set -eo pipefail

VIM_SETUP_REPO="https://github.com/mrpeabody/vim_setup"

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script clones and installs vim, with batteries included."
   echo "It clones the mrpeabody/vim_setup repository for this. If the repository directory already exists,"
   echo "the script will use it as is, so you can make modifications to it, if needed."
   echo "VIM Setup reposity URL: $VIM_SETUP_REPO"
   echo
   echo "Syntax: ./vim.sh [-h|--help|--vim[=<go,csharp,java,go,rust>]]"
   echo "options:"
   echo "[h | --help]                      Print this Help."
   echo "--vim[=<go,csharp,java,rust>]     Specify additional language support in VIM (comma-delimited)."
   echo "                                       Available options: go, csharp, java, and rust."
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
VIM_SETUP="$BASE_DIR/vim_setup"
VIM_SETUP_ARGS=()


# Parse vim_setup additional languages
for arg in "$@"; do
    if [[ "$arg" == --vim=* ]]; then
        IFS=',' read -ra langs <<< "${arg#--vim=}"
        for lang in "${langs[@]}"; do
            VIM_SETUP_ARGS+=("--with-${lang}")
        done
        break
    fi
done


# Clone vim_setup repo, if it does not exist yet 
if [ ! -d "$VIM_SETUP" ]; then
    git clone "$VIM_SETUP_REPO" "$VIM_SETUP"
fi

# Run vim_setup/setup.sh with parsed arguments, if any
(
    cd "$VIM_SETUP"
    bash "$VIM_SETUP/setup.sh" "${VIM_SETUP_ARGS[@]}"
)
