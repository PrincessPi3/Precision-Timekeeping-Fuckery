#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL
## test: bash time_fuckery.sh [t|T]
## reconfigure: bash time_fuckery.sh [r|R] [conf-level-info|conf-level-debug|conf-level-warm|=conf-level-info]
## nuke logs: bash time_fuckery.sh [n|N]
## uninstall: bash time_fuckery.sh [u|U]
## services: bash time_fuckery.sh [s|S] [stop|start|restart|status|enable|disable|=status]
## measure offset (chrony_statistics): bash time_fuckery.sh [mM] [int number of logs to process=500]

# explicitly die on any error
# set -e

# delays in minutes
long_delay=1
short_delay=1

# first install
first_install="git"

# packages
packages="btop build-essential byobu chrony gawk gh grafana gpsd gpsd-clients htop i2c-tools influxdb iptraf-ng util-linux util-linux-extra lynx net-tools nginx picocom pps-tools python3 python3-pip python3-virtualenv python3-setuptools python3-pandas python3-smbus restic ripgrep screen syslog-ng telegraf thefuck wget"

# purge packages
purge_packages='"apt purge -y "bluetooth*" "wireless*" "fonts*" "bluez*" "alsa*"'

# services
services="gpsd gpsd.socket chrony influxdb telegraf grafana-server syslog-ng nginx"

# configs place in system
gpsd="/etc/default/gpsd"
chrony="/etc/chrony/conf.d/precision_timekeeping.conf"
grafana="/etc/grafana/grafana.ini"
influxdb="/etc/influxdb/influxdb.conf"
telegraf="/etc/telegraf/telegraf.conf"
udev_rule="/etc/udev/rules.d/50-tty.rules"
bootfirmwareconfig="/boot/firmware/config.txt"
sudoers="/etc/sudoers"
# hwclockset="/lib/udev/hwclock-set"

# log locations
chrony_tracking_log=/var/log/chrony/tracking.log
chrony_statistics_log=/var/log/chrony/statistics.log
chrony_measurements_log=/var/log/chrony/measurements.log
telegraf_log=/var/log/telegraf/telegraf.log
grafana_log=/var/log/grafana/grafana.log
syslog_log=/var/log/syslog
rootcrontab_log=/var/log/root-crontab.log

# get real username (not root) if run with sudo
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# calculated values
git_dir="/home/$username/Precision-Timekeeping-Fuckery"
status_log="$git_dir/status.txt"
installer_status="$git_dir/installer.tmp"
long_delay_seconds=$(($long_delay * 60))
short_delay_seconds=$(($short_delay * 60))

# stability sleeps
short_sleep () {
    echo -e "\nSleeping $short_delay minutes to make sure everything is as stable as possible\n"
    sleep $short_delay_seconds
}

long_sleep () {
    echo -e "\nSleeping $long_delay minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds
}

# reboot host
run_reboot () {
    echo -e "\n\nREBOOTING IN $short_delay MINUTES!\n\n"
    sudo shutdown -r +$short_delay
}

# to the pause thing like in dos
function hold_for_enter() {
    echo -e "\nPress ENTER to Continue..."
    read -p ""
}

# handle the services
services_cmd () {
    if [ -z $1 ]; then
        echo "Usage: bash services.sh stop|start|restart|status|enable"
        exit
    fi

    echo -e "\nRunning $1 on Services\n"
    sudo bash -c "systemctl $1 $services"
    echo "services complete" >> $status_log
}

# dump/backup configs
dump_configs () {
    dname=./conf-$(date +%s)

    long_sleep

    echo -e "\nBacking up configa\n"

    echo -e "\nMaking $dname\n"
    mkdir $dname

    echo "Copying the config files"
    echo -e "\tBacking up gpsd config"
    sudo cp $gpsd $dname/gpsd
    echo -e "\tBacking up chrony config"
    sudo cp $chrony $dname/chrony.conf 
    echo -e "\tBacking up grafana config"
    sudo cp $grafana $dname/grafana.ini 
    echo -e "\tBacking up influxdb config"
    sudo cp $influxdb $dname/influxdb.conf
    echo -e "\tBacking up telegraf config"
    sudo cp $telegraf $dname/telegraf.conf
    echo -e "\tBacking up /boot/firmware/config.txt"
    sudo cp $telegraf $dname/boot-firmware-config.txt
    echo -e "\tBacking up root crontab"
    sudo crontab -l > $dname/root-crontab

    if [ -f $udev_rule ]; then
        echo -e "\n$udev_rule found, copying as well...\n"
        sudo $udev_rule $dname/50-tty.rules
    fi

    echo -e "\nFixing permissions in $dname...\n"
    sudo chown -R $username:$username $dname
    sudo chmod 775 $dname
    sudo chmod 664 $dname/*

    echo "Compressing up and deleting $dname to $dname.tar.gz..."
    tar czf $dname.tar.gz $dname
    rm -rf $dname

    echo "dump_configs complete" >> $status_log
}

# reconfigure from dir
reconfigure_full () {
    # make sure dir works
    if [ -z $1 ] || [ ! -d "$1" ]; then
        echo "usage reconfigure_full /path/to/config/dir"
        exit 1
    fi

    # new conf file paths
    gpsd_new="$1/gpsd"
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
    services_cmd stop

    dump_configs

    # replace dem by truncation
    echo -e "\nPlacing the new config files by truncation..."
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
    echo -e "\tConfiguring udev\n"
    sudo bash -c "cat $udev_new > $udev_rule"

    # setup and install root crontabs
    echo -e "\nInstalling root cronjobs\n"
    echo -e "\nJUST SAVE AND EXIT NO EDITS\n"
    hold_for_enter
    sudo crontab -e
    (sudo crontab -l 2>/dev/null && sudo cat $crontab_new) | sudo crontab -

    # set up passwordless sudo
    ## backup first
    sudo cp $sudoers "$sudoers.bak"
    ## replace sudoers with mine
    sudo bash -c "cat $sudoers_new > $sudoers"
    ## test it
    sudo visudo -c

    # config hwclockset
    # echo -e "\tConfiguring hwclockset"
    # sudo bash -c "cat $hwclockset_new > $hwclockset"

    # check if /boot/firmware/config.txt is configured yet
    sudo rg -q -e "GPS PPS signals" $bootfirmwareconfig
    grepconfig=$?

    # configure the overlay
    if [ $grepconfig -eq 0 ]; then # if config exists, skip
        echo "$bootfirmwareconfig already updated, skipping..."
    else
        # APPEND to /boot/firmware/config.txt
        echo "Appending configs to $bootfirmwareconfig"
        sudo bash -c "cat $bootfirmwareconfig_new >> $bootfirmwareconfig"
        echo $?
    fi

    # finish the log
    echo "reconfigure_full complete" >> $status_log

    # start da services
    services_cmd start
}

phase_one () {
    echo -e "\n\nStarting 1/5\n\n"

    long_sleep

    # updoot
    echo -e "\nUpdating Software Lists\n"
    sudo apt update 

    # install get for next step
    echo -e "\nInstalling git\n"
    sudo bash -c "apt install -y $first_install"

    # download da thing
    echo -e "\nCloning Repo\n"
    git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git $git_dir

    # makin scripts executable
    chmod +x "$git_dir/*.sh"

    # update the log
    echo -e "START AT $(date +%s) time_fuckery.sh\ncomplete 1/5" >> $status_log

    # update the running file
    echo 1 > $installer_status

    # done
    echo -e "\n\nStage 1/5 Complet\n\n"

    run_reboot
}

phase_two () {
    echo -e "\n\nStarting 2/5\n\n"

    long_sleep

    # rpi-update
    echo -e "\nUpdating Raspberry Pi firmware... DO NOT REBOOT\n"
    sudo rpi-update

    short_sleep

    # run da raspberry pi config script
    clear
    echo -e "\nConfigure Raspberry Pi... DO NOT REBOOT\n"
    echo -e "\nUpdate\n\nEnable I2C Support in raspi-config\n\tInterface Options->I2C->\n\t Would you like the ARM I2C interface to be enabled? <Yes>\n\nInterface Options->Serial Port\n\tWould you like a login shell to be accessible over serial? <No>\n\tWould you like the serial port hardware to be enabled? <Yes>\n\nAdvanced Options\n\tExpand Filesystem\n\nWould you like to reboot now? <No>"
    hold_for_enter
    sudo raspi-config

    # update the running file
    echo 2 > $installer_status

    # update the log
    echo "phase two complete 2/5" >> $status_log

    # notify finish
    echo -e "\n\nPart 2/5 Done!\n\n"

    run_reboot
}

phase_three () {
    echo -e "\n\nStarting 3/5\n\n"

    long_sleep

    # full distribution upgrade
    echo -e "\nFully upgrading, this may take a while...\n"
    sudo apt dist-upgrade -y

    short_sleep

    # cleanup
    echo -e "\nCleaning up...\n"
    sudo apt autoremove -y

    # update the running file
    echo 3 > $installer_status

    # notify finish
    echo -e "\n\nPart 3/5 Done!\n\n"

    # update the log
    echo "phase three complete 3/5" >> $status_log

    run_reboot
}

phase_four () {
    echo -e "\nStarting 4/5\n"

    long_sleep

    # grafana repo and install
    echo -e "\nAdd Grafana repo...\n"
    sudo mkdir -p /etc/apt/keyrings/
    wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg >/dev/null # otherwisse get some stupid binary output to terminal
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list >/dev/null

    # telegraf repo and install
    echo -e "\nAdd Telegraf repo...\n"
    curl --silent --location -O \
    https://repos.influxdata.com/influxdata-archive.key \
    && echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
    | sha256sum -c - && cat influxdata-archive.key \
    | gpg --dearmor \
    | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg >/dev/null \
    && echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
    | sudo tee /etc/apt/sources.list.d/influxdata.list >/dev/null 

    # remove dat key file thing
    if [ -f /home/$username/influxdata-archive.key ]; then
        echo -e "\nRemoving /home/$username/influxdata-archive.key...\n"
        rm -f /home/$username/influxdata-archive.key
    else
        echo -e "\n/home/$username/influxdata-archive.key not found, skipping delete...\n"
    fi

    # updoot
    echo -e "\nGetting new software lists...\n"
    sudo apt update 

    short_sleep

    # clean up
    echo -e "\nDisabling unneeded junk..\n"
    sudo systemctl disable bluetooth
    # sudo systemctl disable fake-hwclock
    sudo update-rc.d -f fake-hwclock remove

    # install da packages
    echo -e "\nInstalling packages, this may take a while...\n"
    sudo bash -c "apt install -y $packages"

    short_sleep

    # purging da junk
    # dont actually think this is at worth the space savings
    echo -e "\nPurging unneeded junk...\n"
    sudo bash -c "apt purge -y $purge_packages"

    # check if pps-gpio is in /etc/modules already
    rg -e "pps-gpio" /etc/modules
    gerppps=$?

    # add pps-gpio to modules
    if [ $gerppps -eq 0 ]; then
        echo -e "\npps-gpio already in /etc/modules, skipping..n"
    else
        echo -e "\nAdding pps-gpio to /etc/modules...\n"
        sudo bash -c "echo pps-gpio >> /etc/modules"
    fi

    short_sleep

    # cleanup
    echo -e "\nCleaning up...\n"
    sudo apt autoremove -y 

    short_sleep

    # handle users serial shit
    ## self
    echo -e "\nGiving $username the right permissions...\n"
    sudo usermod -aG dialout $username
    sudo usermod -a -G i2c $username
    sudo usermod -a -G tty $username
    ## service users
    echo -e "\nGiving service users the right permissions...\n"
    sudo usermod -aG dialout gpsd
    sudo usermod -aG dialout _chrony
    sudo usermod -aG i2c _chrony
    sudo usermod -aG i2c gpsd
    sudo usermod -aG tty _chrony
    sudo usermod -aG tty gpsd

    short_sleep

    # installing ble.sh
    echo -e "\nInstalling BLE.sh\n"
    bashrc="/home/$username/.bashrc"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX=/home/$username/.local
    echo -e "\n# ble.sh" >> $bashrc
    echo "source -- /home/$username/.local/share/blesh/ble.sh" >> $bashrc

    short_sleep

    # general-scripts-and-system-ssssssetup
    echo -e "\nInstalling general-scripts-and-system-ssssssetup\n"
    curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh?nocache=$RANDOM | sudo "$SHELL" && bash /usr/share/customscripts/configure_webhook.sh && exec "$SHELL"

    # update the running file
    echo 4 > $installer_status

    # update the log
    echo "phase 4 complete 4/5" >> $status_log

    # finish
    echo -e "\n\nPart 4/5 Done\n\n"

    run_reboot
}

phase_five () {
    echo -e "\n\nStarting part 5/5\n\n"

    long_sleep

    # reconfigure to normal mode
    echo -e "\nStarting configurAation\n"
    # info level
    # bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
    # running (warn level) 
    # bash ./reconfig_full.sh ./running-warn-level-conf
    # debug/dev mode
    reconfigure_full "$git_dir/conf-level-info"

    # enable services
    echo -e "\nEnabling Services..."
    services_cmd enable

    # unclear if this is needed
    # edit dis
    ## comment out and add note
    ##     # commented out manually to use rtc
    ##     # if [ -e /run/systemd/system ] ; then
    ##     #  exit 0
    ##     # fi
    ## Also comment out the two lines
    ##     #  /sbin/hwclock --rtc=$dev --systz --badyear
    ##     and
    ##     # /sbin/hwclock --rtc=$dev --systz
    # echo "Editing hwclock-set file"
    # sudo nano /lib/udev/hwclock-set

    # update the log
    echo "phase 5 done 5/5\nCOMPLETE AT $(date +%s)" >> $status_log

    # finish the tmp file
    echo "installed" > $installer_status

    # finish
    echo -e "\nPart 5/5 Done! Yaay! Done!\n"

    run_reboot
}

# updoot repo any time the repo is downloaded
updoot_repo () {
    echo -e "\nUpdating\n"

    git -C $git_dir pull
    ret=$?

    if [ $ret -ne 0 ]; then
        echo -e "\n\nSCRIPT UPDATED! RE-RUN\n\n"
        exit 1 # explicit fail
    fi
}

show_running_configs () {
    sudo less $gpsd
    sudo less $chrony
    sudo less $grafana
    sudo less $influxdb
    sudo less $telegraf
    sudo less $udev_rule
    sudo less $bootfirmwareconfig
    sudo crontab -l
}

test () {
    # status of services
    services_cmd status

    # test pps
    ## pps0
    echo "Testing PPS0"
    sudo ppstest /dev/pps0
    ## pps1
    echo "Testing PPS1"
    sudo ppstest /dev/pps1

    # check gps
    echo "Checking Normal GPS"
    sudo cgps

    # check gpsmon
    echo "Checking Timekeeping GPS"
    sudo gpsmon

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

    # rtc
    clear
    echo -e "Reading from hardware RTC\n"
    sudo hwclock -r
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

    show_running_configs

    # clean up
    clear
}

uninstall () {
    services_cmd stop
    services_cmd disable
    nuke_logs
    cleanup
    sudo apt purge -y telegraf grafana influxdb gpsd gpsd-clients chrony syslog-ng
    sudo apt install -y raspi-config
    cd ~
    rm -rf ~/Precision-Timekeeping-Fuckery
    run_reboot
}

function backup_logs () {
    # make log backup dir with unix timestamp
    dname="./log_backup_$(date +%s)"
    mkdir $dname

    # copy em
    sudo cp $chrony_tracking_log $dname/chrony_tracking.log
    sudo cp $chrony_statistics_log $dname/chrony_statistics.log
    sudo cp $chrony_measurements_log $dname/chrony_measurements.log
    sudo cp $telegraf_log $dname/telegraf.log
    sudo cp $grafana_log $dname/grafana.log
    sudo cp $syslog_log $dname/syslog
    sudo cp $rootcrontab_log $dname/syslog

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
    sudo bash -c "echo '' > $chrony_tracking_log"
    sudo bash -c "echo '' > $chrony_statistics_log"
    sudo bash -c "echo '' > $chrony_measurements_log"
    sudo bash -c "echo '' > $telegraf_log"
    sudo bash -c "echo '' > $grafana_log"
    sudo bash -c " echo '' > $rootcrontab_log"
    sudo bash -c "echo '' > $syslog_log"
}

cleanup() {
    echo "Nuking all those stupid files"

    rm -f $git_dir/influxdata-archive.key 2>/dev/null
    rm -f $git_dir/status.txt 2>/dev/null
    rm -f $git_dir/*.tar.gz 2>/dev/null
    rm -f $git_dir/*.log 2>/dev/null
    rm -f $git_dir/*.bak* 2>/dev/null
    rm -f $git_dir*.~ 2>/dev/null

    echo "Cleanup done!"
}

# usage chrony_statistics [int number of logs to process]
# measure_offset
chrony_statistics () {
    numlogs=$1
    
    tmp_log=$git_dir/chrony_statistics.log

    sudo tail -n $numlogs /var/log/chrony/statistics.log > $tmp_log
    sudo chown $USER:$USER $tmp_log
    echo "$(wc -l $tmp_log) logs entered"
    python $git_dir/chrony_statistics.py
    rm -f $tmp_log
}

# always run
echo -e "\n\nPrecision Timekeeping Fuckery :3\n\n"

# test mode
if [[ "$1" =~ ^[tT]{1} ]]; then
    test
    exit 0
# reconfigure mode
elif [[ "$1" =~ ^[rR]{1} ]]; then
    if [ -z "$2" ]; then
        default_conf=$git_dir/conf-level-info
    else
        default_conf=$git_dir/$2
    fi

    reconfigure_full $default_conf
# nuke logs mode
elif [[ "$1" =~ ^[nN]{1} ]]; then
    cleanup
    backup_logs
    clear_logs
# uninstall modde
elif [[ "$1" =~ ^[uU]{1} ]]; then
    uninstall
# measure offset (chrony_statustics.sh)
elif [[ "$1" =~ ^[mM]{1} ]]; then
    if [ -z "$2" ]; then
        default_numlogs=500
    else
        default_numlogs=$2
    fi

    chrony_statistics $default_numlogs
# services modde
elif [[ "$1" =~ ^[sS]{1} ]]; then
    if [ -z "$2" ]; then
        default_service_action=status
    else
        default_service_action=$2
    fi
    
    services_cmd $default_service_action
else
    # do da install
    # if da file is there
    if [ -f $status_log ]; then
        updoot_repo

        if [[ "$(cat $installer_status)" == 1 ]]; then
            phase_two
        elif [[ "$(cat $installer_status)" == 2 ]]; then
            phase_three
        elif [[ "$(cat $installer_status)" == 3 ]]; then
            phase_four
        elif [[ "$(cat $installer_status)" == 4 ]]; then
            phase_five
        else
            echo -e "\nAlready installed!\n\tUsage: time_fuckery.sh test"
            exit
        fi
    # if da file is not there
    else
        phase_one
    fi
fi
