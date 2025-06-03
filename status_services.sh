#!/bin/bash
echo "Services Status"
sudo systemctl status gpsd chrony influxdb telegraf grafana-server syslog-ng
