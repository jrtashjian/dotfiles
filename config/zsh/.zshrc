# Zsh configuration
if [ -f ~/.aliases ]; then
    \. ~/.aliases
fi

# Editor
export EDITOR=nvim

# Path
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH" # opencode

# Node Version Manager (https://github.com/nvm-sh/nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Starship prompt
preexec() { echo; } # Add a newline before each command for better readability
eval "$(starship init zsh)"