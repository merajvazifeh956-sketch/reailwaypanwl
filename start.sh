#!/bin/bash
set -euo pipefail

# --- config -------------------------------------------------
WEB_PORT="${WEB_PORT:-2053}"
WEB_PATH="${WEB_PATH:-panel}"          # set to "" for the panel at root "/"

# strip leading/trailing slashes from the path
WEB_PATH="${WEB_PATH#/}"
WEB_PATH="${WEB_PATH%/}"

if [ -n "${WEB_PATH}" ]; then
  WEB_BASE="/${WEB_PATH}"
  URL_PATH="/${WEB_PATH}"
else
  WEB_BASE="/"
  URL_PATH=""
fi

mkdir -p /etc/x-ui

cat > /etc/x-ui/config.json <<EOF
{
  "webPort": ${WEB_PORT},
  "webBasePath": "${WEB_BASE}",
  "webListen": "0.0.0.0",
  "logLevel": "info"
}
EOF

# --- print connection info -----------------------------------
PANEL_URL=""
PROXY_ADDR=""
if [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  PANEL_URL="https://${RAILWAY_PUBLIC_DOMAIN}${URL_PATH}"
fi
if [ -n "${RAILWAY_TCP_PROXY_DOMAIN:-}" ]; then
  PROXY_ADDR="${RAILWAY_TCP_PROXY_DOMAIN}:${RAILWAY_TCP_PROXY_PORT:-443}"
fi

{
  echo "=============================================="
  echo "  login    : admin / admin"
  if [ -n "${PANEL_URL}" ]; then
    echo "  panel    : ${PANEL_URL}"
  fi
  if [ -n "${PROXY_ADDR}" ]; then
    echo "  proxy    : ${PROXY_ADDR}"
    echo "             (use THIS address:port in clients, not 443)"
  fi
  echo "=============================================="
} | tee /etc/x-ui/panel-info.txt

# --- run -----------------------------------------------------
cd /opt/app
exec ./x-ui
