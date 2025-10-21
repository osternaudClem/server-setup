#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Configuring SSH for secure access..."

# Ensure .ssh folder for cletus
SSH_DIR="/home/cletus/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R cletus:cletus "$SSH_DIR"

# SSH hardening (disable root login)
SSHD_CONFIG="/etc/ssh/sshd_config"
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak_$(date +%F_%T)"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
systemctl restart ssh
ok "Root SSH login disabled"

IP=$(hostname -I | awk '{print $1}')

echo -e "\n${CYAN}📘 === SSH SETUP GUIDE ===${NC}"
echo -e "➡️  You can now connect using the 'cletus' user:"
echo -e "   ${GREEN}ssh cletus@${IP}${NC}\n"
echo -e "🔑 To enable passwordless login, on your *local computer*, run:"
echo -e "   ${YELLOW}ssh-copy-id cletus@${IP}${NC}\n"
echo -e "   or manually append your public key to:"
echo -e "   ${CYAN}/home/cletus/.ssh/authorized_keys${NC}\n"
echo -e "🧠 Then you can test it with:"
echo -e "   ${GREEN}ssh cletus@${IP}${NC}"
