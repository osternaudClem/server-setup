#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Creating user 'cletus'..."

read -rp "Enter password for new user 'cletus': " -s USER_PASS
echo

useradd -m -s /bin/zsh cletus || true
echo "cletus:$USER_PASS" | chpasswd
usermod -aG sudo,docker cletus || true

ok "User 'cletus' created and added to sudo & docker groups"
