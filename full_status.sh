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
echo "Detecting I2C Devices"
sudo i2cdetect -y 1
pause

# rtc
echo "Reading from hardware RTC"
sudo hwclock -r
pause