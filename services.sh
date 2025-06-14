#!/bin/bash
set -e

if [ -z $1 ]; then
    echo "Usage: bash services.sh stop|start|restart|status|enable"
    exit
fi

echo "Running $1 on Services"
sudo systemctl $1 gpsd chrony influxdb telegraf grafana-server syslog-ng 1>/dev/null
echo "services complete" >> ./status.txt
