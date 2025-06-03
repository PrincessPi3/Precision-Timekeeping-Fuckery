#!/bin/bash
set -e

if [ -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

dname=./conf-$(date +%s)
mkdir $dname

sudo cp /etc/default/gpsd $dname/gpsd
sudo cp /etc/chrony/chrony.conf $dname/chrony.conf 
sudo cp /etc/grafana/grafana.ini $dname/grafana.ini 
sudo cp /etc/influxdb/influxdb.conf $dname/influxdb.conf
sudo cp /etc/telegraf/telegraf.conf $dname/telegraf.conf
sudo cp /etc/udev/rules.d/50-tty.rules $dname/50-tty.rules 2> /dev/null

sudo chown -R $username:$username $dname
sudo chmod 775 $dname
sudo chmod 664 $dname/*