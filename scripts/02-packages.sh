#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Updating system & installing packages..."

apt update && apt upgrade -y
apt install -y curl git ufw zsh fail2ban docker.io docker-compose caddy bat eza vim unzip wget gnupg ca-certificates

ok "Base packages installed"

# --- Install LazyDocker ---
info "Installing lazydocker..."
LAZY_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/jesseduffield/lazydocker/releases/download/${LAZY_VERSION}/lazydocker_${LAZY_VERSION#v}_Linux_x86_64.tar.gz" -o /tmp/lazydocker.tar.gz
tar xf /tmp/lazydocker.tar.gz -C /usr/local/bin lazydocker
chmod +x /usr/local/bin/lazydocker
ok "lazydocker installed"

# --- Enable services ---
systemctl enable --now docker
systemctl enable --now caddy
systemctl enable --now fail2ban
ok "Docker, Caddy, and Fail2Ban enabled"

# --- Firewall ---
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw --force enable
ok "Firewall configured"
