#!/bin/bash

# Exit immediately if a command exist with a non-zero status
set -eEo pipefail

export DOTFILES_PATH="$HOME/.local/share/jrtashjian-dotfiles"

DOTFILES_REPO="jrtashjian/dotfiles"

echo -e "\nCloning dotfiles from: https://github.com/${DOTFILES_REPO}.git"
rm -rf $DOTFILES_PATH
git clone "https://github.com/${DOTFILES_REPO}.git" $DOTFILES_PATH >/dev/null
