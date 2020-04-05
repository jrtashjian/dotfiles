#!/bin/bash
# Install command-line tools using Homebrew

set -o errexit
set -o nounset

# Enable alternate versions of Casks to be installed.
brew tap homebrew/cask-versions

brew cask install 1password
brew cask install vlc
brew cask install visual-studio-code
brew cask install virtualbox
brew cask install docker
brew cask install tableplus
brew cask install slack
brew cask install firefox-developer-edition
brew cask install transmission
brew cask install istat-menus

brew cask install openemu
brew cask install steam
brew cask install moonlight