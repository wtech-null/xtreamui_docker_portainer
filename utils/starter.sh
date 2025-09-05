#!/usr/bin/env bash
set -euo pipefail

if [ -f "/home/xtreamcodes/iptv_xtream_codes/start_services.sh" ]; then
    echo "Xtream-UI already installed, starting service..."
    echo "Starting cron..."
    service cron start >/dev/null 2>&1
    sleep 2
    echo "Force cron reload..."
    service cron force-reload >/dev/null 2>&1
    sleep 2
    echo "Stopping service..."
    /home/xtreamcodes/iptv_xtream_codes/service stop >/dev/null 2>&1
    sleep 2
    echo "Starting service..."
    /home/xtreamcodes/iptv_xtream_codes/service start >/dev/null 2>&1
    sleep 2
    echo "Checking service..."
    /home/xtreamcodes/iptv_xtream_codes/status >/dev/null 2>&1
    sleep 2
    echo "Checking service..."
    /home/xtreamcodes/iptv_xtream_codes/status >/dev/null 2>&1
    echo "Done!"
fi

