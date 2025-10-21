# Shared library for colors and helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}ℹ️  $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
err()   { echo -e "${RED}❌ $*${NC}" >&2; }
