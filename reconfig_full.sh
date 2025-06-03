#!/bin/bash
set -e  # dir on any error

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
## new conf file paths
gpsd_new=""$1/gpsd""
chrony_new="$1/chrony.conf"
grafana_new="$1/grafana.ini"
influxdb_new="$1/influxdb.conf"
telegraf_new="$1/telegraf.conf"
udev_new="$1/50-tty.rules"

# stop da services
bash ./stop_services.sh

# backup conf
bash ./dump_configs.sh

# replace dem by truncation
sudo bash -c "cat $gpsd_new > $gpsd"
sudo bash -c "cat $chrony_new > $chrony"
sudo bash -c "cat $grafana_new > $grafana"
sudo bash -c "cat $influxdb_new > $influxdb"
sudo bash -c "cat $telegraf_new > $telegraf"
sudo bash -c "cat $udev_new > $udev_rule"

# restart da services
bash ./start_services.sh

# show services status
# bash ./status_services.sh