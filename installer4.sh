#!/bin/bash
set -e

# reconfigure to normal mode
echo "Starting configure script..."
# info level
# bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
# running (warn level) 
# bash ./reconfig_full.sh ./running-warn-level-conf
# debug/dev mode
bash ./reconfig_full.sh ./debug-level-conf

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

rm -f ./status.txt

# reboot rq
echo "Part 4 done!"
# echo "Rebooting now!"
# sudo reboot
echo "Rebooting in 5 minutes!!"
sudo shutdown -r +5