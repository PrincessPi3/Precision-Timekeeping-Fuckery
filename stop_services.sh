#!/bin/bash
echo "Stopping Services"
sudo systemctl stop gpsd chrony influxdb telegraf grafana-server syslog-ng