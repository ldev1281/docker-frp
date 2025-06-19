#!/usr/bin/env sh
set -e

# Required
: "${FRP_HOST:?Missing FRP_HOST}"
: "${FRP_PORT:?Missing FRP_PORT}"
: "${FRP_TOKEN:?Missing FRP_TOKEN}"
CADDY_LOCAL_HOST="${CADDY_LOCAL_HOST:-caddy}"
FRP_REMOTE_HTTP_PORT="${FRP_REMOTE_HTTP_PORT:-80}"
FRP_LOCAL_HTTP_PORT="${FRP_LOCAL_HTTP_PORT:-80}"
FRP_REMOTE_HTTPS_PORT="${FRP_REMOTE_HTTPS_PORT:-443}"
FRP_LOCAL_HTTPS_PORT="${FRP_LOCAL_HTTPS_PORT:-443}"

echo "[INFO] Starting frp-client"
echo "[INFO] frp-server: $FRP_HOST:$FRP_PORT"
echo "[INFO] Remote/local http: ${FRP_HOST}:${FRP_REMOTE_HTTP_PORT}/${CADDY_LOCAL_HOST}:${FRP_LOCAL_HTTP_PORT}"
echo "[INFO] Remote/local https: ${FRP_HOST}:${FRP_REMOTE_HTTPS_PORT}/${CADDY_LOCAL_HOST}:${FRP_LOCAL_HTTPS_PORT}"
{
  echo "[common]"
  echo "server_addr = ${FRP_HOST}"
  echo "server_port = ${FRP_PORT}"
  echo "token = ${FRP_TOKEN}"
  echo ""
  echo "[web-http]"
  echo "type = tcp"
  echo "local_ip = ${CADDY_LOCAL_HOST}"
  echo "local_port = ${FRP_LOCAL_HTTP_PORT}"
  echo "remote_port = ${FRP_REMOTE_HTTP_PORT}"
  echo ""
  echo "[web-https]"
  echo "type = tcp"
  echo "local_ip = ${CADDY_LOCAL_HOST}"
  echo "local_port = ${FRP_LOCAL_HTTPS_PORT}"
  echo "remote_port = ${FRP_REMOTE_HTTP_PORT}"
} >/frpc.ini

exec /usr/local/bin/frpc -c /frpc.ini
