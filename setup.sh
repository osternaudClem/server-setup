#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting modular server setup...${NC}"

# --- Check root ---
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ This script must be run as root${NC}"
  exit 1
fi

# --- Ensure dependencies ---
echo -e "${YELLOW}📦 Checking required packages...${NC}"
apt update -y >/dev/null
apt install -y git curl sudo >/dev/null
echo -e "${GREEN}✅ Dependencies ready${NC}"

# --- Clone or update repo ---
SETUP_DIR="/tmp/server-setup"

if [ -d "$SETUP_DIR/.git" ]; then
  echo -e "${YELLOW}🔄 Updating existing setup repository...${NC}"
  git -C "$SETUP_DIR" fetch --quiet origin main
  git -C "$SETUP_DIR" reset --hard origin/main --quiet
else
  echo -e "${YELLOW}📥 Cloning setup repository...${NC}"
  rm -rf "$SETUP_DIR"
  git clone --depth=1 https://github.com/osternaudClem/server-setup.git "$SETUP_DIR" >/dev/null
fi

cd "$SETUP_DIR"

# --- Make sure all scripts are executable ---
chmod +x scripts/*.sh || true

# --- Execute scripts in ascending order ---
for script in scripts/[0-9][0-9]-*.sh; do
  echo -e "${YELLOW}➡️  Running $(basename "$script")...${NC}"
  bash "$script"
done

# --- Final message ---
echo -e "\n${GREEN}✅ All setup scripts completed successfully!${NC}"
echo -e "${YELLOW}💡 Tip:${NC} You can re-run this anytime to apply updates."
