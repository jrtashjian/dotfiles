#!/usr/bin/env bash

# This script is used to bootstrap a new workstation and
# meant for quick & easy install via:
#   $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/jrtashjian/dotfiles/master/bootstrap.sh)"

set -o errexit
set -o nounset

REPO=${REPO:-https://github.com/jrtashjian/dotfiles.git}
DEST=~/Repositories/jrtashjian/dotfiles

function info() {
    printf "\n\e[0;1;37m➜ $*\e[0m\n"
}

function success() {
    printf "\e[0;32m✔︎ $*\e[0m\n"
}

function prompt() {
    while true; do
        read -p $'\e[0;1mDo you wish to bootstrap this workstation? \e[2m[Y/N] ' yn
        case $yn in
            [Yy]* ) bootstrap; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

function op_signin() {
    local sign_in_address
    local email_address
    local secret_key

    info "Signing into 1Password..."

    if [ ! -f $HOME/.op/config ]; then
        read -p "Enter the sign in address [my.1password.com]: " sign_in_address
        sign_in_address=${sign_in_address:-my.1password.com}
        read -p "Enter the email address: " email_address
        read -p "Enter the secret key: " secret_key
        eval "$(op signin $sign_in_address $email_address $secret_key)"
    fi

    if ! op list users >/dev/null 2>&1; then
        sign_in_address=$(cat $HOME/.op/config | jq -r '.accounts|.[0].shorthand')
        eval "$(op signin $sign_in_address)"
    fi
}

function op_get_ssh_keys() {
    local ssh_key_items

    if [ ! -d "$HOME/.ssh" ]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi

    info "Retrieving SSH keys from 1Password..."

    ssh_key_items=$(op list items | jq --compact-output -r '
        map( select( .overview.tags[]? | contains("ssh-key") ) ) |
        .[].uuid
    ')

    for uuid in $ssh_key_items; do
        local item=$(op get item ${uuid})
        local fileName=$(echo ${item} | jq -r '.details.documentAttributes.fileName')
        local fileData=$(op get document ${uuid})
        local passphrase=$(echo ${item} | jq -r '.details.sections | map(select(.fields[]?)) | .[0].fields[0].v?')

        if [ ! -f "$HOME/.ssh/$fileName" ]; then
            info "Adding SSH key: $fileName"
            op get document ${uuid} > "$HOME/.ssh/$fileName"
            chmod 600 "$HOME/.ssh/$fileName"
        fi

        if [ "$passphrase" != "null" ]; then
            echo "\$passphrase is NOT empty"
        fi
    done
}

function bootstrap() {

    if ! xcode-select -p &> /dev/null; then
        info "Installing Xcode command line tools..."
        xcode-select --install
    fi

    if ! type brew &> /dev/null; then
        info "Installing Homebrew..."
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
    fi

    if [ ! -x /usr/local/bin/jq ]; then
        info "Installing jq..."
        brew install jq
    fi

    if [ ! -x /usr/local/bin/op ]; then
        info "Installing 1Password command-line tool..."
        brew cask install 1password-cli
    fi

    op_signin
    op_get_ssh_keys

    if [ ! -d  $DEST ]; then
        info "Cloning repository..."
        mkdir -p "$(dirname $DEST)"; git clone $REPO $DEST
    else
        info "Updating repository..."
        git -C $DEST pull
    fi
}

function main() {
    if [ $# -eq 1 ] && [ $1 = "-q" ]; then
        bootstrap
    else
        prompt
    fi
}

main "$@"
