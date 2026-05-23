#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

export DOTFILES_PATH="$HOME/.local/share/jrtashjian-dotfiles"
DOTFILES_REPO="jrtashjian/dotfiles"

# Check if we're already in the dotfiles repo
if ! ([ "$PWD" = "$DOTFILES_PATH" ] && git rev-parse --git-dir >/dev/null 2>&1); then
    # Clone or pull the dotfiles repo
    if [ -d "$DOTFILES_PATH" ]; then
        echo -e "\nPulling latest changes in dotfiles repo."
        cd "$DOTFILES_PATH"
        git pull >/dev/null
    else
        echo -e "\nCloning dotfiles from: https://github.com/${DOTFILES_REPO}.git"
        git clone "https://github.com/${DOTFILES_REPO}.git" "$DOTFILES_PATH" >/dev/null
    fi
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

# Helper function to parse source:target pair and return requested part
parse_pair() {
    local pair="$1"
    local part="$2"
    IFS=':' read -r source target <<< "$pair"
    case "$part" in
        source) echo "$source" ;;
        target) echo "$target" ;;
        *) echo "Invalid part: $part" >&2; return 1 ;;
    esac
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

# Define files to copy if they don't exist (source:target)
files_to_copy=(
    "$DOTFILES_PATH/config/git/.gitconfig.local.example:$HOME/.gitconfig.local"
)

# Define files to symlink (source:target)
files_to_symlink=(
    "$DOTFILES_PATH/config/zsh/.zshrc:$HOME/.zshrc"
    "$DOTFILES_PATH/config/zsh/.aliases:$HOME/.aliases"
    "$DOTFILES_PATH/config/starship.toml:$HOME/.config/starship.toml"
)

# Copy each file if target doesn't exist
for pair in "${files_to_copy[@]}"; do
    source=$(parse_pair "$pair" "source")
    target=$(parse_pair "$pair" "target")
    if [ ! -f "$target" ]; then
        cp "$source" "$target"
        echo "Copied $(basename "$source") to $target"
    fi
done

# Symlink each file
for pair in "${files_to_symlink[@]}"; do
    source=$(parse_pair "$pair" "source")
    target=$(parse_pair "$pair" "target")
    create_symlink "$target" "$source"
done

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ ! -r /etc/os-release ]; then
                echo "Error: /etc/os-release not found. Unsupported Linux distribution." >&2
                exit 1
            fi

            # shellcheck disable=SC1091
            . /etc/os-release

            case "${ID:-}" in
                arch)
                    echo "arch"
                    ;;
                debian|ubuntu)
                    echo "debian"
                    ;;
                *)
                    echo "Error: Unsupported Linux distribution '${ID:-unknown}'." >&2
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Error: Unsupported operating system '$(uname -s)'." >&2
            exit 1
            ;;
    esac
}

# Install packages
install_packages() {
    local os="$1"
    echo "Installing packages for $os..."

    case "$os" in
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                echo "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git zsh tmux neovim ghostty font-fira-code-nerd-font
            if ! command -v starship >/dev/null 2>&1; then
                echo "Installing Starship..."
                /bin/sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
            fi
            ;;
        debian)
            # obtain sudo privileges upfront
            sudo -v || { echo "Error: This script requires sudo privileges." >&2; exit 1; }
            sudo apt update
            sudo apt install -y git zsh tmux neovim
            # Install font only if not already installed
            if ! fc-list :family | grep -i "firacode nerd font" >/dev/null 2>&1; then
                echo "Installing Fira Code Nerd Font..."
                mkdir /tmp/firacode
                curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip -o /tmp/firacode/firacode.zip
                unzip /tmp/firacode/firacode.zip -d /tmp/firacode
                sudo mkdir -p "$HOME/.local/share/fonts"
                sudo mv /tmp/firacode/*.ttf "$HOME/.local/share/fonts/"
                rm -rf /tmp/firacode
            fi
            if ! command -v starship >/dev/null 2>&1; then
                echo "Installing Starship..."
                /bin/sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
            fi
            # Set zsh as default shell for current user
            if [ "$SHELL" != "/bin/zsh" ]; then
                sudo chsh -s /bin/zsh "$USER"
            fi
            ;;
        arch)
            sudo pacman -S --needed git zsh neovim ghostty ttf-fira-code nerd-fonts-fira-code
            ;;
        *)
            echo "Error: No package installation defined for '$os'." >&2
            exit 1
            ;;
    esac
}

# Main setup
os=$(detect_os)
install_packages "$os"
