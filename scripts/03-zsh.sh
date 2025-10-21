#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Setting up Zsh & Oh My Zsh..."

su - cletus -c '
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💫 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  PLUGDIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [ ! -d "$PLUGDIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGDIR/zsh-autosuggestions"
  fi

  if [ ! -d "$PLUGDIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGDIR/zsh-syntax-highlighting"
  fi

  sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/" ~/.zshrc
'

# Default shells
chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh cletus
ok "Zsh installed and set as default for root and cletus"

# Auto-reload into zsh if interactive
if [[ $- == *i* ]]; then
  exec zsh
fi
