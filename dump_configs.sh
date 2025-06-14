#!/bin/bash
set -e

if [ -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo "Backing up configs..."

dname=./conf-$(date +%s)

echo "Making $dname"
mkdir $dname

echo "Copying the config files"
echo -e "\tBacking up gpsd config"
sudo cp /etc/default/gpsd $dname/gpsd
echo -e "\tBacking up chrony config"
sudo cp /etc/chrony/chrony.conf $dname/chrony.conf 
echo -e "\tBacking up grafana config"
sudo cp /etc/grafana/grafana.ini $dname/grafana.ini 
echo -e "\tBacking up influxdb config"
sudo cp /etc/influxdb/influxdb.conf $dname/influxdb.conf
echo -e "\tBacking up telegraf config"
sudo cp /etc/telegraf/telegraf.conf $dname/telegraf.conf
echo -e "\tBacking up /boot/firmware/config.txt"
sudo cp /boot/firmware/config.txt $dname/boot-firmware-config.txt
echo -e "\tBacking up gheclock-set config"
sudo cp /lib/udev/hwclock-set $dname/hwclock-set
echo -e "\tBacking up root crontab"
sudo crontab -l $dname/root-crontab
echo -e "\tBacking up /etc/modules"
sudo cp /etc/modules $dname/root-crontab

if [ -f /etc/udev/rules.d/50-tty.rules ]; then
    echo "/etc/udev/rules.d/50-tty.rules found, copying as well..."
    sudo cp /etc/udev/rules.d/50-tty.rules $dname/50-tty.rules
fi

echo "Fixing permissions in $dname..."
sudo chown -R $username:$username $dname
sudo chmod 775 $dname
sudo chmod 664 $dname/*

echo "Compressing up and deleting $dname to $dname.tar.gz..."
tar czf $dname.tar.gz $dname
rm -rf $dname

echo "dump_configs.sh complete" >> ./status.txt