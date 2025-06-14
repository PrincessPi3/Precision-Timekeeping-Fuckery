#!/bin/bash
bash services.sh stop
bash services disable
bash nuke_logs.sh
bash cleanup.sh
sudo apt purge -y telegraf grafana influxdb gpsd gpsd-clients chrony syslog-ng
sudo apt install -y raspi-config
cd ~
rm -rf ~/Precision-Timekeeping-Fuckery
sudo reboot