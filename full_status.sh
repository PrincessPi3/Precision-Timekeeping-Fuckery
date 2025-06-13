#!/bin/bash
# status of services
bash ./services.sh status

# test pps
echo "Testing PPS"
sudo ppstest /dev/pps*

# check gps
echo "Checking Normal GPS"
cgps

# check gpsmon
echo "Checking Timekeeping GPS"
gpsmon

# do same with watch
echo "Watching chronyc sources"
watch chronyc sources

# track
echo "Watching chronyc tracking"
watch -n 10 chronyc tracking

# i2c
clear
echo -e "Detecting I2C Devices\n"
sudo i2cdetect -y 1
echo -e "\nPress ENTER to Continue..."
read -p ""

# rtc
clear
echo -e "Reading from hardware RTC\n"
sudo hwclock -r
echo -e "\nPress ENTER to Continue..."
read -p ""