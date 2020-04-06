# Add additional directories to $PATH
export PATH="$PATH:/usr/local/sbin" # Add Homebrew to $PATH
export PATH="$PATH:$HOME/.composer/vendor/bin" # Add Composer to $PATH
export PATH="$PATH:/usr/local/opt/mysql@5.7/bin" # Add MySQL to $PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mtashjianjr/.oh-my-zsh"

# Set the theme to load
ZSH_THEME="common"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git osx common-aliases composer cp
    docker-compose encode64
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local sessions
export EDITOR='vim'

# Personal aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

alias resetdock='defaults delete com.apple.dock; killall Dock'
alias resetlaunchpad='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock'

# Add Java to PATH
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH=${JAVA_HOME}/bin:$PATH

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
