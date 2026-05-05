# Zsh configuration

# Editor
export EDITOR=nvim

# Path
export PATH=$HOME/.local/bin:$PATH
export PATH=/Users/jrtashjian/.opencode/bin:$PATH # opencode

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Starship prompt
eval "$(starship init zsh)"