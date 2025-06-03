#!/bin/bash
# status of services
bash ./status_services

# test pps
echo "Testing PPS"
sudo ppstest /dev/pps0

# check gps
echo "Checking Normal GPS"
cgps

# check gpsmon
echo "Checking Timekeeping GPS"
gpsmon

# chek chrony sources
# chronyc sources

# do same with watch
echo "Watching chronyc sources"
watch chronyc sources

# track
echo "Watching chronyc tracking"
watch -n 10 chronyc tracking