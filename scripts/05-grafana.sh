#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Installing Grafana Agent..."

curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
apt update && apt install -y grafana-agent

mkdir -p /etc/grafana-agent
if [ -f "/tmp/server-setup/config/grafana-agent.yaml" ]; then
  cp /tmp/server-setup/config/grafana-agent.yaml /etc/grafana-agent.yaml
  chown grafana-agent:grafana-agent /etc/grafana-agent.yaml
  systemctl enable --now grafana-agent
  ok "Grafana Agent configured and started"
else
  warn "No grafana-agent.yaml found in ./config/, skipping..."
fi
