#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting server setup...${NC}"

# --- Check root ---
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ This script must be run as root${NC}"
  exit 1
fi

# --- Create user ---
read -rp "Enter password for new user 'cletus': " -s USER_PASS
echo
useradd -m -s /bin/bash cletus || true
echo "cletus:$USER_PASS" | chpasswd
usermod -aG sudo,docker cletus
echo -e "${GREEN}✅ User 'cletus' created and added to sudo & docker groups${NC}"

# --- System update & packages ---
echo -e "${YELLOW}📦 Installing packages...${NC}"
apt update && apt upgrade -y
apt install -y curl git ufw zsh fail2ban docker.io docker-compose caddy bat eza lazydocker vim unzip wget

# --- Enable & start services ---
systemctl enable --now docker
systemctl enable --now caddy
systemctl enable --now fail2ban

# --- Setup firewall ---
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw --force enable
echo -e "${GREEN}✅ Firewall configured${NC}"

# --- Setup ZSH + Oh My Zsh ---
su - cletus -c '
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💫 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true
  sed -i "s/plugins=(git)/plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)/" ~/.zshrc
'
echo -e "${GREEN}✅ ZSH + plugins installed for cletus${NC}"

# --- Setup Caddy with modular sites ---
echo -e "${YELLOW}🧱 Configuring Caddy...${NC}"
mkdir -p /etc/caddy/sites

if [ -d "./config/caddy" ]; then
  cp ./config/caddy/Caddyfile /etc/caddy/Caddyfile
  cp -r ./config/caddy/sites/. /etc/caddy/sites/
  chown -R caddy:caddy /etc/caddy
  systemctl reload caddy
  echo -e "${GREEN}✅ Caddy configuration installed and reloaded${NC}"
else
  echo -e "${YELLOW}⚠️ No ./config/caddy directory found, skipping Caddy setup...${NC}"
fi

# --- Setup Grafana Agent (metrics + logs) ---
echo -e "${YELLOW}📊 Installing Grafana Agent (for metrics + logs)...${NC}"
curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt update && apt install -y grafana-agent

mkdir -p /etc/grafana-agent
if [ -f "./config/grafana-agent.yaml" ]; then
  cp ./config/grafana-agent.yaml /etc/grafana-agent.yaml
  chown grafana-agent:grafana-agent /etc/grafana-agent.yaml
  systemctl enable --now grafana-agent
  echo -e "${GREEN}✅ Grafana Agent configured and started${NC}"
else
  echo -e "${YELLOW}⚠️ No grafana-agent.yaml found in ./config/, skipping...${NC}"
fi

# --- Copy dotfiles / custom configs ---
if [ -d "./config/dotfiles" ]; then
  echo -e "${YELLOW}📂 Copying dotfiles...${NC}"
  cp -r ./config/dotfiles/. /home/cletus/
  chown -R cletus:cletus /home/cletus
fi

echo -e "${GREEN}✅ All configurations applied!${NC}"
echo -e "${YELLOW}✨ Setup complete — reboot recommended.${NC}"
