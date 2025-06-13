#!/bin/bash
# set -e  # die on any error

# make sure dir works
if [ -z $1 ] || [ ! -d "$1" ]; then
    echo "usage bash reconfig_full.sh /path/to/config/dir"
    exit
fi

# paths
## place in system
gpsd="/etc/default/gpsd"
chrony="/etc/chrony/conf.d/precision_timekeeping.conf"
grafana="/etc/grafana/grafana.ini"
influxdb="/etc/influxdb/influxdb.conf"
telegraf="/etc/telegraf/telegraf.conf"
udev_rule="/etc/udev/rules.d/50-tty.rules"
bootfirmwareconfig="/boot/firmware/config.txt"
hwclockset="/lib/udev/hwclock-set"
## new conf file paths
gpsd_new=""$1/gpsd""
chrony_new="$1/chrony.conf"
grafana_new="$1/grafana.ini"
influxdb_new="$1/influxdb.conf"
telegraf_new="$1/telegraf.conf"
udev_new="$1/50-tty.rules"
bootfirmwareconfig_new="$1/boot-firmware-config.txt"
hwclockset_new="$1/hwclock-set"
crontab_new="$1/root-crontab"

# stop da services
bash ./services.sh stop 1>/dev/null 2>/dev/null

# backup conf
bash ./dump_configs.sh

# replace dem by truncation
echo "Placing the new config files by truncation..."
echo -e "\tConfiguring gpsd"
sudo bash -c "cat $gpsd_new > $gpsd"
echo -e "\tConfiguring chrony"
sudo bash -c "cat $chrony_new > $chrony"
echo -e "\tConfiguring grafana"
sudo bash -c "cat $grafana_new > $grafana"
echo -e "\tConfiguring influxdb"
sudo bash -c "cat $influxdb_new > $influxdb"
echo -e "\tConfiguring telegraf"
sudo bash -c "cat $telegraf_new > $telegraf"
echo -e "\tConfiguring udev"
sudo bash -c "cat $udev_new > $udev_rule"
echo -e "\tConfiguring hwclockset"
sudo bash -c "cat $hwclockset_new > $hwclockset"

# check if /boot/firmware/config.txt is configured yet
grep -q -e "GPS PPS signals" /boot/firmware/config.txt
grepconfig=$?

# configure the overlay
if [ $grepconfig -eq 0 ]; then # if config exists, skip
    echo "/boot/firmware/config.txt already updated, skipping..."
else
    # APPEND to /boot/firmware/config.txt
    echo "Appending configs to /boot/firmware/config.txt"
    sudo bash -c "cat $bootfirmwareconfig_new >> $bootfirmwareconfig"
    echo $?
    # pps and gpio uart
    # echo "Adding lines to /boot/firmware/config.txt to enable pps and gpio uart..."
    # sudo bash -c "echo '# GPS PPS GPIO Signal' >> /boot/firmware/config.txt"
    # sudo bash -c "echo 'dtoverlay=pps-gpio,gpiopin=18' >> /boot/firmware/config.txt" # pps
    # 
    # sudo bash -c "echo '# GPS GPIO UART' >> /boot/firmware/config.txt"
    # sudo bash -c "echo 'enable_uart=1' >> /boot/firmware/config.txt" # enable uart
    # sudo bash -c "echo 'init_uart_baud=115200' >> /boot/firmware/config.txt" # set baudrate here too
    # # i2c
    # sudo bash -c "echo '# I2C Hardware RTC Overlay' >> /boot/firmware/config.txt"
    # sudo bash -c "echo 'dtoverlay=i2c-rtc,ds3231' >> /boot/firmware/config.txt"
fi

echo "Setting up crontab"
sudo crontab $crontab_new

# start da services
bash ./services.sh start 1>/dev/null