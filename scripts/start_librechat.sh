#!/usr/bin/env bash
set -euo pipefail

# LibreChat Starter
# - Ensures Docker Desktop is running
# - Chooses docker compose or docker-compose
# - Starts or restarts the stack safely
# - Validates basic configuration
# - Opens the app in the browser when ready

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_DIR"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "$1"; }
ok() { log "${GREEN}✓ $1${NC}"; }
warn() { log "${YELLOW}⚠ $1${NC}"; }
err() { log "${RED}✗ $1${NC}"; }

# 1) Check Docker CLI
if ! command -v docker >/dev/null 2>&1; then
  err "Docker is not installed. Please install Docker Desktop for Mac: https://www.docker.com/products/docker-desktop/"
  exit 1;
fi

# 2) Ensure Docker Desktop is running
if ! docker info >/dev/null 2>&1; then
  warn "Docker Desktop is not running. Attempting to start Docker Desktop..."
  if command -v open >/dev/null 2>&1; then
    open -a Docker >/dev/null 2>&1 || true
  fi
  # Wait up to ~90s for Docker to come up
  for i in {1..30}; do
    if docker info >/dev/null 2>&1; then
      ok "Docker is ready."
      break
    fi
    sleep 3
    if [[ $i -eq 30 ]]; then
      err "Docker did not become ready in time. Please launch Docker Desktop and retry."
      exit 1
    fi
  done
fi

# 3) Choose docker compose flavor
DOCKER_COMPOSE="docker compose"
if ! docker compose version >/dev/null 2>&1; then
  if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
  else
    err "Neither 'docker compose' nor 'docker-compose' is available."
    exit 1
  fi
fi

# 4) Basic YAML validation (optional)
if command -v ruby >/dev/null 2>&1; then
  if ! ruby -ryaml -e "YAML.load_file('librechat.yaml')" >/dev/null 2>&1; then
    warn "librechat.yaml has YAML syntax issues. Please fix before continuing."
  else
    ok "librechat.yaml syntax looks valid."
  fi
else
  warn "Ruby not found; skipping YAML validation."
fi

# 5) Read PORT from .env (defaults to 3080)
PORT="3080"
if [[ -f .env ]]; then
  # Safe parse of simple VAR=VALUE lines
  if grep -qE '^PORT=' .env; then
    PORT_VAL="$(grep -E '^PORT=' .env | tail -1 | cut -d= -f2-)"
    # strip quotes/spaces
    PORT_VAL="${PORT_VAL//\"/}"
    PORT_VAL="${PORT_VAL//\'/}"
    PORT_VAL="${PORT_VAL// /}"
    if [[ -n "$PORT_VAL" ]]; then PORT="$PORT_VAL"; fi
  fi
else
  warn ".env not found. Using default PORT=$PORT"
fi

APP_URL="http://localhost:${PORT}"

# 6) Check running state of main container
MAIN_CONTAINER="LibreChat" # from docker-compose.yml container_name
is_container_running() {
  docker inspect -f '{{.State.Running}}' "$MAIN_CONTAINER" 2>/dev/null | grep -q true
}

is_http_ready() {
  curl -fsS -m 3 "$APP_URL" >/dev/null 2>&1
}

wait_until_http_ready() {
  local max=$1; local i=0
  until is_http_ready; do
    sleep 2; i=$((i+1))
    if (( i >= max )); then return 1; fi
  done
  return 0
}

start_stack() {
  warn "Starting LibreChat stack..."
  $DOCKER_COMPOSE up -d
}

restart_stack() {
  warn "Restarting LibreChat stack..."
  # Use restart if available, else fallback to up -d
  if $DOCKER_COMPOSE restart >/dev/null 2>&1; then
    :
  else
    $DOCKER_COMPOSE up -d
  fi
}

# 7) Decide whether to start or restart
if is_container_running; then
  if is_http_ready; then
    ok "LibreChat is already running at ${APP_URL}"
  else
    warn "Container is running but the app isn't responding yet. Restarting services..."
    restart_stack
  fi
else
  start_stack
fi

# 8) Wait for readiness
if wait_until_http_ready 45; then
  ok "LibreChat is ready at ${APP_URL}"
else
  warn "LibreChat did not become ready within the expected time. Check logs for details."
fi

# 9) Open in browser (best-effort)
if command -v open >/dev/null 2>&1; then
  open "$APP_URL" >/dev/null 2>&1 || true
fi

exit 0
