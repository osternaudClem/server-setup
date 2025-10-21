#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting modular server setup...${NC}"

# Ensure git + curl are installed
apt update -y >/dev/null
apt install -y git curl >/dev/null

# Clone repo if missing (for remote execution)
if [ ! -d "/tmp/server-setup" ]; then
  echo -e "${YELLOW}📥 Cloning setup repository...${NC}"
  git clone --depth=1 https://github.com/osternaudClem/server-setup.git /tmp/server-setup
fi

cd /tmp/server-setup

# Run all numbered scripts in order
for script in scripts/[0-9][0-9]-*.sh; do
  echo -e "${YELLOW}➡️  Running $(basename "$script")...${NC}"
  bash "$script"
done

echo -e "${GREEN}✅ All setup scripts completed successfully!${NC}"
