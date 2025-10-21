#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Finalizing setup..."

# Ensure sudo is installed
if ! command -v sudo &>/dev/null; then
  apt update -y >/dev/null
  apt install -y sudo >/dev/null
fi

echo -e "${YELLOW}✨ Setup complete — reboot recommended.${NC}"

# If running interactively, auto switch to cletus
if [[ -t 1 ]]; then
  echo -e "${CYAN}💡 Switching to user 'cletus'...${NC}"
  sudo -u cletus -i
else
  echo -e "${YELLOW}💡 You can now connect as:${NC} ${GREEN}ssh cletus@$(hostname -I | awk '{print $1}')${NC}"
fi
