#!/bin/bash
# set -e
# get real user
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

if [ -z $1 ]; then
    echo "Usage: bash services.sh stop|start|restart|status|enable"
    exit
fi

echo "Running $1 on Services"
sudo systemctl $1 gpsd chrony influxdb telegraf grafana-server syslog-ng
echo "services complete" >> /home/$username/status.txt
