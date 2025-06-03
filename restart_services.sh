#!/bin/bash
echo "Restarting Services"
sudo systemctl restart gpsd chrony influxdb telegraf grafana-server syslog-ng