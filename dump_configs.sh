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
sudo cp /etc/default/gpsd $dname/gpsd
sudo cp /etc/chrony/chrony.conf $dname/chrony.conf 
sudo cp /etc/grafana/grafana.ini $dname/grafana.ini 
sudo cp /etc/influxdb/influxdb.conf $dname/influxdb.conf
sudo cp /etc/telegraf/telegraf.conf $dname/telegraf.conf

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