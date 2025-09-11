#!/usr/bin/env bash
set -euo pipefail

if [ -f "/home/xtreamcodes/iptv_xtream_codes/start_services.sh" ]; then
    echo "Xtream-UI already installed, starting service..."
    echo "Starting cron..."
    service cron start >/dev/null 2>&1 || true
    sleep 8
    echo "Force cron reload..."
    service cron force-reload >/dev/null 2>&1 || true
    sleep 8
    echo "Stopping service..."
    /home/xtreamcodes/iptv_xtream_codes/service stop >/dev/null 2>&1 || true
    sleep 8
    echo "Set-up permissions..."
    bash /home/xtreamcodes/iptv_xtream_codes/permissions.sh >/dev/null 2>&1 || true
    sleep 8
    echo "Starting service..."
    sleep 8
    exec /home/xtreamcodes/iptv_xtream_codes/service start || true
fi

echo "Xtream-UI not installed yet. Sleeping..."
exec sleep infinity
