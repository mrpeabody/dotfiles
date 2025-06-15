#!/usr/bin/env bash


# Base dir is where the script is located
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


# Determine the user fonts location, OS-dependent
FONT_SRC="$BASE_DIR/fonts"
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DST="$HOME/Library/Fonts"
else
    FONT_DST="$HOME/.local/share/fonts"
fi
mkdir -p "$FONT_DST"


echo "Installing font directories from $FONT_SRC to $FONT_DST..."
for dir in "$FONT_SRC"/*/; do
    font_name=$(basename "$dir")
    target_dir="$FONT_DST/$font_name"

    # Remove existing font directory if it exists
    if [ -d "$target_dir" ]; then
        echo "Removing existing font directory: $target_dir"
        rm -rf "$target_dir"
    fi

    echo "Copying $font_name to $FONT_DST..."
    cp -r "$dir" "$FONT_DST/"
done


# Refresh font cache (Linux only)
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Updating font cache..."
    fc-cache -f "$FONT_DST"
fi


echo "Font installation complete"
