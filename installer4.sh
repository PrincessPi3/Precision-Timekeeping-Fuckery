#!/bin/bash
set -e

echo "Updating this repo..."
git pull 1>/dev/null

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# handle users serial shit
## self
echo "Giving  $username the right permissions..."
sudo usermod -aG dialout $username
## service users
echo "Giving service users the right permissions..."
sudo usermod -aG dialout gpsd
sudo usermod -aG dialout _chrony

# reconfigure to normal mode
echo "Starting configure script..."
bash ./reconfig_full.sh ./working-normal-level-conf

# enable services
echo "Enabling Services..."
sudo systemctl enable gpsd 1>/dev/null
sudo systemctl enable chrony 1>/dev/null
sudo systemctl enable influxdb 1>/dev/null
sudo systemctl enable grafana-server 1>/dev/null
sudo systemctl enable telegraf 1>/dev/null
sudo systemctl enable grafana-server 1>/dev/null
sudo systemctl enable syslog-ng 1>/dev/null
sudo systemctl enable logrotate 1>/dev/null

# reboot rq
echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5