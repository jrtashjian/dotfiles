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

    info "Sign into 1Password account ..."

    if [ ! -f $HOME/.op/config ]; then
        read -p "Enter the sign in address [my.1password.com]: " sign_in_address
        sign_in_address=${sign_in_address:-my.1password.com}
        read -p "Enter the email address: " email_address
        read -p "Enter the secret key: " secret_key
        eval "$(op signin $sign_in_address $email_address $secret_key)"
    fi

    if ! op list users >/dev/null 2>&1; then
        sign_in_address=$(cat $HOME/.op/config | jq -r '.accounts|.[0].shorthand')
        eval $(op signin $sign_in_address)
    fi
}

function bootstrap() {

    info "Checking for Xcode command line tools"
    if ! xcode-select -p &> /dev/null; then
        info "Installing Xcode command line tools..."
        xcode-select --install
    fi
    success "Xcode command line tools installed"

    info "Checking for Homebrew"
    if ! type brew &> /dev/null; then
        info "Installing Homebrew..."
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
    fi
    success "Homebrew installed"

    info "Checking for jq"
    if [ ! -x /usr/local/bin/jq ]; then
        info "Installing jq..."
        brew install jq
    fi
    success "jq installed"

    info "Checking for 1Password CLI"
    if [ ! -x /usr/local/bin/op ]; then
        info "Installing 1Password command-line tool..."
        brew cask install 1password-cli
    fi
    success "1Password command-line tool installed"

    op_signin

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
