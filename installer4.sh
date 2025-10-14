#!/bin/bash
# set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# reconfigure to normal mode
echo "Starting configure script..."
# info level
# bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
# running (warn level) 
# bash ./reconfig_full.sh ./running-warn-level-conf
# debug/dev mode
bash /home/$username/Precision-Timekeeping-Fuckery/reconfig_full.sh /home/$username/Precision-Timekeeping-Fuckery/info-level-conf-huawaii

# enable services
echo "Enabling Services..."
echo -e "\tEnabling gpsd on boot"
sudo systemctl enable gpsd
echo -e "\tEnabling chrony on boot"
sudo systemctl enable chrony
echo -e "\tEnabling influxdb on boot"
sudo systemctl enable influxdb
echo -e "\tEnabling telegraf on boot"
sudo systemctl enable telegraf
echo -e "\tEnabling chrony on boot"
sudo systemctl enable grafana-server
echo -e "\tEnabling syslog-ng on boot"
sudo systemctl enable syslog-ng
echo -e "\tEnabling logrotate on boot"
sudo systemctl enable logrotate

echo "done!" > /home/$username/Precision-Timekeeping-Fuckery/status.txt

# reboot rq
echo "Part 4 Done!"
# echo "Rebooting now!"
# sudo reboot
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3