#!/bin/bash
set -e

echo "Updating this repo..."
git pull 1>/dev/null 2>/dev/null

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
# quiet level
# bash ./reconfig_full.sh ./reconfig_full.sh ./working-normal-level-conf
# running (warn level) 
# bash ./reconfig_full.sh ./working-warn-level-conf
# debug/dev mode
bash ./reconfig_full.sh ./debug-level-conf-dev

# enable services
echo "Enabling Services..."
echo -e "\tEnabling gpsd on boot"
sudo systemctl enable gpsd 1>/dev/null
echo -e "\tEnabling chrony on boot"
sudo systemctl enable chrony 1>/dev/null
echo -e "\tEnabling influxdb on boot"
sudo systemctl enable influxdb 1>/dev/null
echo -e "\tEnabling telegraf on boot"
sudo systemctl enable telegraf 1>/dev/null
echo -e "\tEnabling chrony on boot"
sudo systemctl enable grafana-server 1>/dev/null
echo -e "\tEnabling syslog-ng on boot"
sudo systemctl enable syslog-ng 1>/dev/null
echo -e "\tEnabling logrotate on boot"
sudo systemctl enable logrotate 1>/dev/null

# reboot rq
echo "Part 4 done!"
echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5