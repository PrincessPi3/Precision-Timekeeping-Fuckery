#!/bin/bash
echo "Starting Services"
sudo systemctl start gpsd chrony influxdb telegraf grafana-server syslog-ng