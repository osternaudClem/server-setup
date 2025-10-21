#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Setting up Zsh & Oh My Zsh..."

# Ensure zsh is installed
apt install -y zsh git curl >/dev/null

# Install Oh My Zsh for root (optional)
if [ ! -d "/root/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Oh My Zsh for cletus
su - cletus -c '
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💫 Installing Oh My Zsh for cletus..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
'

# Apply your custom .zshrc if available
if [ -f "./config/dotfiles/.zshrc" ]; then
  cp ./config/dotfiles/.zshrc /home/cletus/.zshrc
  chown cletus:cletus /home/cletus/.zshrc
  echo -e "${GREEN}✅ Custom .zshrc applied for cletus${NC}"
fi

echo -e "${GREEN}✅ Zsh installed for both root and cletus${NC}"
