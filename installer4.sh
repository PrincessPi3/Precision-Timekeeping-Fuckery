#!/bin/bash
# set -e

# get real user
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# initial delay to make sure its good
echo "Sleeping 3 minutes"
sleep 180

# reconfigure to normal mode
echo "Starting configure script..."
# info level
# bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
# running (warn level) 
# bash ./reconfig_full.sh ./running-warn-level-conf
# debug/dev mode
bash /home/$username/Precision-Timekeeping-Fuckery/reconfig_full.sh /home/$username/Precision-Timekeeping-Fuckery/info-level-conf-huawaii

# safety delay
echo "Sleeping 60 seconds to make sure its as stable as possible"
sleep 60

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

# edit dis
## comment out and add note
##     # commented out manually to use rtc
##     # if [ -e /run/systemd/system ] ; then
##     #  exit 0
##     # fi
## Also comment out the two lines
##     #  /sbin/hwclock --rtc=$dev --systz --badyear
##     and
##     # /sbin/hwclock --rtc=$dev --systz
echo "Editing hwclock-set file"
sudo nano /lib/udev/hwclock-set

# update the log
echo "done!" > /home/$username/Precision-Timekeeping-Fuckery/status.txt

# finish
echo "Part 4 Done!"

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3