#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

info "Performing pre-checks..."

if [[ $EUID -ne 0 ]]; then
  err "This script must be run as root."
  exit 1
fi

ok "Running as root ✅"
