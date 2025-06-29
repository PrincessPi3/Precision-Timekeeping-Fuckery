#!/bin/bash

function hold_for_enter() {
    echo -e "\nPress ENTER to Continue..."
    read -p ""
}

# status of services
bash ./services.sh status

# test pps
echo "Testing PPS"
sudo ppstest /dev/pps0

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
watch chronyc tracking

# i2c
clear
echo -e "Detecting I2C Devices\n"
sudo i2cdetect -y 1
hold_for_enter

# rtc
clear
echo -e "Reading from hardware RTC\n"
sudo hwclock -r
hold_for_enter

# devices
## tty devices
clear 
echo "tty devices"
ls -lh /dev/tty* | sort -k9
hold_for_enter

## pps devices
clear
echo "pps devices"
ls -lh /dev/pps* | sort -k9
hold_for_enter

# i2c devices
clear
echo "i2c devices"
ls -lh /dev/i2c* | sort -k9
hold_for_enter

# rtc devices
clear
echo "rtc devices"
ls -lh /dev/rtc* | sort -k9
hold_for_enter

# hwclock status
clear
echo "hwclock status"
sudo hwclock --verbose
hold_for_enter

# root crontab
clear
echo "root crontab"
sudo crontab -l
hold_for_enter

# clean up
clear