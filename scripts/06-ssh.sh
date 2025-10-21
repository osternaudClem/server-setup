#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Securing SSH & generating keys..."

# Generate key for cletus
su - cletus -c '
  SSH_DIR="$HOME/.ssh"
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  if [ ! -f "$SSH_DIR/id_ed25519" ]; then
    echo "🔑 Generating SSH key for GitHub & remote access..."
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -N "" -C "cletus@$(hostname)"
  fi

  chmod 600 "$SSH_DIR/id_ed25519"
  chmod 644 "$SSH_DIR/id_ed25519.pub"
'

# Disable root SSH login
SSHD_CONFIG="/etc/ssh/sshd_config"
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak_$(date +%F_%T)"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
systemctl restart ssh
ok "Root SSH login disabled"

# Display SSH guide
IP=$(hostname -I | awk '{print $1}')
PUB_KEY=$(cat /home/cletus/.ssh/id_ed25519.pub)

echo -e "\n${CYAN}📘 === SSH SETUP GUIDE ===${NC}"
echo -e "1️⃣ Copy this public key to GitHub:\n${YELLOW}${PUB_KEY}${NC}"
echo -e "➡️  Add at ${CYAN}https://github.com/settings/keys${NC}\n"
echo -e "2️⃣ Connect from your computer using:\n${GREEN}ssh cletus@${IP}${NC}\n"
echo -e "3️⃣ Test GitHub SSH:\n${YELLOW}ssh -T git@github.com${NC}\n"
