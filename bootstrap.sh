#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

export DOTFILES_PATH="$HOME/.local/share/jrtashjian-dotfiles"
DOTFILES_REPO="jrtashjian/dotfiles"

# Clone or pull the dotfiles repo
if [ -d "$DOTFILES_PATH" ]; then
    echo -e "\nPulling latest changes in dotfiles repo."
    cd "$DOTFILES_PATH"
    git pull >/dev/null
else
    echo -e "\nCloning dotfiles from: https://github.com/${DOTFILES_REPO}.git"
    git clone "https://github.com/${DOTFILES_REPO}.git" "$DOTFILES_PATH" >/dev/null
fi

# Function to create symlink idempotently
create_symlink() {
    local target="$1"
    local source="$2"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "Symlink $target already exists and is correct."
    else
        rm -rf "$target"
        ln -snf "$source" "$target"
        echo "Created symlink $target -> $source"
    fi
}

# Ensure config directory exists
if [ ! -d "$DOTFILES_PATH/config" ]; then
    echo "Error: $DOTFILES_PATH/config does not exist."
    exit 1
fi

# Dynamically create symlinks for each subdirectory in config/
for dir in "$DOTFILES_PATH/config"/*/; do
    if [ -d "$dir" ]; then
        folder_name=$(basename "$dir")
        source="$DOTFILES_PATH/config/$folder_name"
        target="$HOME/.config/$folder_name"
        create_symlink "$target" "$source"
    fi
done
