#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Configuring Caddy..."

mkdir -p /etc/caddy/sites

if [ -d "/tmp/server-setup/config/caddy" ]; then
  cp /tmp/server-setup/config/caddy/Caddyfile /etc/caddy/Caddyfile
  cp -r /tmp/server-setup/config/caddy/sites/. /etc/caddy/sites/
  chown -R caddy:caddy /etc/caddy
  systemctl reload caddy
  ok "Caddy configuration installed and reloaded"
else
  warn "No config/caddy directory found; skipping..."
fi
