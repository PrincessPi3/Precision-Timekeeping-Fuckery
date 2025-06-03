#!/bin/bash
echo "Restarting Services"
sudo systemctl restart gpsd chrony influxdb telegraf grafana-server syslog-ng
# sudo systemctl restart gpsd
# sudo systemctl restart chrony
# sudo systemctl restart influxdb
# sudo systemctl restart telegraf
# sudo systemctl restart grafana-server
# sudo systemctl restart syslog-ng