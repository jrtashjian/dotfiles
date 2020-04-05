#!/bin/bash
# Install command-line tools using Homebrew

set -o errexit
set -o nounset

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed

brew install wget
brew install vim

brew install git
brew install node
brew install zsh
brew install composer

# Laravel Valet
brew install php
brew install mysql@5.7

# Composer
composer global require laravel/valet

# Mac App Store CLI interface
brew install mas

mas lucky "Things 3"
mas lucky "Magnet"