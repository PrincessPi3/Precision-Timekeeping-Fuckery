#!/bin/bash
set -e
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# handle users serial shit
## self
echo "Giving your user the right permissions"
sudo usermod -aG tty $username
sudo usermod -aG root $username
sudo usermod -aG dialout $username
sudo usermod -aG plugdev $username
## service users
echo "Giving service users the right permissions"
sudo usermod -aG dialout gpsd
sudo usermod -aG dialout _chrony

# reconfigure to normal mode
echo "Starting configure script"
bash ./reconfig_full.sh ./working-normal-level-conf

# enable services
echo "Enabling Services"
sudo systemctl enable gpsd
sudo systemctl enable chrony
sudo systemctl enable influxdb
sudo systemctl enable telegraf
sudo systemctl enable grafana-server
sudo systemctl enable syslog-ng

# reboot rq
echo "Rebooting in one minute"
sudo shutdown -r +1