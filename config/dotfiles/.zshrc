# ===========================================
# 🧠 Cletus ZSH Configuration (Server Edition)
# ===========================================

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"  # simple and clear theme

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- Path ---
export PATH="$HOME/.local/bin:$PATH"

# --- History ---
HISTSIZE=5000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# --- Prompt ---
autoload -Uz promptinit && promptinit
PROMPT='%F{green}%n@%m%f %F{blue}%~%f %# '

# --- Aliases ---
alias ll='eza -la --icons --group-directories-first'
alias la='eza -a'
alias l='eza -1'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cat='batcat'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias edit='vim'
alias reload='source ~/.zshrc && echo "🔁 Reloaded ~/.zshrc"'
alias reboot-now='sudo reboot now'
alias shutdown-now='sudo shutdown now'

# --- Tools ---
export EDITOR="vim"
export BAT_THEME="OneHalfDark"

# --- Enable plugins manually if not loaded ---
if [ -f "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Welcome message ---
echo "👋 Welcome, $USER — use 'update' to keep your system fresh."
