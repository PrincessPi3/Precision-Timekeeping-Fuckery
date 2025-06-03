#!/bin/bash
set -e # die on any error

# log locations
chrony_tracking=/var/log/chrony/tracking.log
chrony_statistics=/var/log/chrony/statistics.log
chrony_measurements=/var/log/chrony/measurements.log
telegraf=/var/log/telegraf/telegraf.log
grafana=/var/log/grafana/grafana.log
syslog=/var/log/syslog

function backup_logs() {
    # make log backup dir with unix timestamp
    dname="./log_backup_$(date +%s)"
    mkdir $dname

    # copy em
    sudo cp $chrony_tracking $dname/chrony_tracking.log
    sudo cp $chrony_statistics $dname/chrony_statistics.log
    sudo cp $chrony_measurements $dname/chrony_measurements.log
    sudo cp $telegraf $dname/telegraf.log
    sudo cp $grafana $dnamme/grafana.log
    sudo cp $syslog $dname/syslog

    # fix permissions
    sudo chown -R $USER:$USER $dname
    chmod 775 $dname
    chmod 664 $dname/*

    # compress logs
    tar fczvv $dname.tar.gz $dname

    # cleanup
    rm -rf $dname
}

function clear_logs() {
    # truncate logs to empty files
    sudo bash -c "echo '' > $chrony_tracking"
    sudo bash -c "echo '' > $chrony_statistics"
    sudo bash -c "echo '' > $chrony_measurements"
    sudo bash -c "echo '' > $telegraf"
    sudo bash -c "echo '' > $grafana"
    # sudo bash -c "echo '' > $syslog" # leaving syslog alone for now
}

backup_logs
clear_logs