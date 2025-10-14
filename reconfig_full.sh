#!/bin/bash
# set -e  # die on any error

# get real user
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

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
sudoers="/etc/sudoers"
# hwclockset="/lib/udev/hwclock-set"

# new conf file paths
gpsd_new=""$1/gpsd""
chrony_new="$1/chrony.conf"
grafana_new="$1/grafana.ini"
influxdb_new="$1/influxdb.conf"
telegraf_new="$1/telegraf.conf"
udev_new="$1/50-tty.rules"
bootfirmwareconfig_new="$1/boot-firmware-config.txt"
crontab_new="$1/root-crontab"
sudoers_new="$1/sudoers"
# hwclockset_new="$1/hwclock-set"

# stop da services
bash /home/$username/services.sh stop

# backup conf
bash /home/$username/dump_configs.sh

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

# setup and install root crontabs
# echo -e "Installing crontabs! just save file and exit with no edits"
# read -p "Press ENTER to Continue"
# sudo crontab -e
echo -e "\nInstalling root cronjobs\n"
(sudo crontab -l 2>/dev/null && sudo cat $crontab_new) | sudo crontab -

# set up passwordless sudo
## backup first
sudo cp /etc/sudoers /etc/sudoers.bak
## replace sudoers with mine
sudo bash -c "cat $sudoers_new > $sudoers"
## test it
sudo visudo -c
## Check for users approval to continue
read -p "Press ENTER to Continue"

# config hwclockset
# echo -e "\tConfiguring hwclockset"
# sudo bash -c "cat $hwclockset_new > $hwclockset"

# check if /boot/firmware/config.txt is configured yet
sudo grep -q -e "GPS PPS signals" /boot/firmware/config.txt
grepconfig=$?

# configure the overlay
if [ $grepconfig -eq 0 ]; then # if config exists, skip
    echo "/boot/firmware/config.txt already updated, skipping..."
else
    # APPEND to /boot/firmware/config.txt
    echo "Appending configs to /boot/firmware/config.txt"
    sudo cat $bootfirmwareconfig_new >> $bootfirmwareconfig
    echo $?
fi

# start da services
bash /home/$username/services.sh start

echo "reconfig_full.sh complete" >> /home/$username/status.txt