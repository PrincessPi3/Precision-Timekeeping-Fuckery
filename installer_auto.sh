#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL

# explicitly die on any error
# set -e

# delays in minutes
long_delay=3
short_delay=1

# first install
first_install="git"

# packages
packages="util-linux gawk telegraf grafana influxdb restic build-essential net-tools htop btop screen byobu python3 python3-pip python3-virtualenv python3-setuptools thefuck wget lynx nmap zip unzip 7zip ripgrep pps-tools gh gpsd gpsd-clients chrony syslog-ng iptraf-ng i2c-tools picocom"

# purge packages
purge_packages='"apt purge -y "bluetooth*" "usb*" "wireless*" "pci*" "fonts*" "bluez*" "alsa*"'

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

short_sleep () {
    echo -e "\nSleeping $short_delay minutes to make sure everything is as stable as possible\n"
    sleep $short_delay_seconds
}

long_sleep () {
    echo -e "\nSleeping $long_delay minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds
}

run_reboot () {
    echo -e "\nREBOOTING IN $long_delay MINUTES\n"
    sudo shutdown -r +$long_delay
}

services_cmd () {
    short_sleep

    if [ -z $1 ]; then
        echo "Usage: bash services.sh stop|start|restart|status|enable"
        exit
    fi

    echo -e "\nRunning $1 on Services\n"
    sudo systemctl $1 gpsd chrony influxdb telegraf grafana-server syslog-ng
    echo "services complete" >> $status_log
}

dump_configs () {
    dname=./conf-$(date +%s)

    long_sleep

    echo -e "\nBacking up configa\n"

    echo -e "\nMaking $dname\n"
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
    # sudo cp /lib/udev/hwclock-set $dname/hwclock-set
    echo -e "\tBacking up root crontab"
    sudo crontab -l > $dname/root-crontab
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

    echo "dump_configs complete" >> ./status.txt
}

reconfigure_full () {
    # make sure dir works
    if [ -z $1 ] || [ ! -d "$1" ]; then
        echo "usage reconfigure_full /path/to/config/dir"
        exit 1
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
    services_cmd stop

    dump_configs

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
    echo -e "\nInstalling root cronjobs\n"
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
    sudo grep -q -e "GPS PPS signals" $bootfirmwareconfig
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
    echo -e "\nStarting 1/5\n"

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

    # update the log
    echo -e "START AT $(date +%s)installer_auto.sh\ncomplete 1/5" >> $status_log

    # update the running file
    echo 1 > $installer_status

    # done
    echo -e "\nStage 1/5 Complet\n"

    run_reboot
}

phase_two () {
    echo -e "\nStarting 2/5\n"

    long_sleep

    # rpi-update
    echo -e "\nUpdating Raspberry Pi firmware... DO NOT REBOOT\n"
    sudo rpi-update

    short_sleep

    # run da raspberry pi config script
    clear
    echo -e "\nConfigure Raspberry Pi... DO NOT REBOOT\n"
    echo -e "\nEnable I2C Support in raspi-config\n\tInterface Options->I2C->\n\t Would you like the ARM I2C interface to be enabled? <Yes>\n\nInterface Options->Serial Port\n\tWould you like a login shell to be accessible over serial? <No>\n\tWould you like the serial port hardware to be enabled? <Yes>\n\nAdvanced Options\n\tExpand Filesystem\n\nWould you like to reboot now? <No>"
    read -p "Press ENTER to Continue"
    sudo raspi-config

    # notify finish
    echo -e "\nPart 2/5 Done!\n"

    # update the running file
    echo 2 > $installer_status

    # update the log
    echo "phase two complete 2/5" >> $status_log

    run_reboot
}

phase_three () {
    echo -e "\nStarting 3/5\n"

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
    echo -e "\nPart 3/5 Done!\n"

    # update the log
    echo "Installer2.sh complete 3/5" >> $status_log

    run_reboot
}

phase_four () {
    echo -e "\nStarting 5/5\n"

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
    sudo update-rc.d -f fake-hwclock remove
    sudo systemctl disable fake-hwclock

    # install da packages
    echo -e "\nInstalling packages, this may take a while...\n"
    sudo bash -c "apt install -y $packages"

    short_sleep

    # purging da junk
    # dont actually think this is at worth the space savings
    # echo "Purging unneeded junk..."
    # sudo bash -c "apt purge -y $purge_packages"

    # check if pps-gpio is in /etc/modules already
    grep -e "pps-gpio" /etc/modules
    gerppps=$?

    # add pps-gpio to modules
    if [ $gerppps -eq 0 ]; then
        echo -e "\npps-gpio already in /etc/modules, skipping..n"
    else
        echo -e "\nAdding pps-gpio to /etc/modules...\n"
        sudo bash -c "echo 'pps-gpio' >> /etc/modules"
    fi

    # cleanup
    echo -e "\nCleaning up...\n"
    sudo apt autoremove -y 

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
    curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh?nocache=$RANDOM | sudo $SHELL

    # update the running file
    echo 4 > $installer_status

    # update the log
    echo "installer3.sh complete 4/5" >> $status_log

    # finish
    echo -e "\nPart 4/5 Done\n!"

    run_reboot
}

phase_five () {
    echo -e "\nStarting 1/5\n"

    long_sleep

    # reconfigure to normal mode
    echo -e "\nStarting configurAation\n"
    # info level
    # bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
    # running (warn level) 
    # bash ./reconfig_full.sh ./running-warn-level-conf
    # debug/dev mode
    reconfigure_full "$git_dir/info-level-conf-huawaii"

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # enable services
    echo -e "\nEnabling Services..."
    echo -e "\tEnabling gpsd on boot"
    sudo systemctl enable gpsd
    echo -e "\tEnabling chrony on boot"
    sudo systemctl enable chrony
    echo -e "\tEnabling influxdb on boot"
    sudo systemctl enable influxdb
    echo -e "\tEnabling telegraf on boot"
    sudo systemctl enable telegraf
    echo -e "\tEnabling grafana on boot"
    sudo systemctl enable grafana-server
    echo -e "\tEnabling syslog-ng on boot"
    sudo systemctl enable syslog-ng
    echo -e "\tEnabling logrotate on boot"
    sudo systemctl enable logrotate

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

    # update the running file
    echo 5 > $installer_status

    # update the log
    echo "installer4.sh done 5/5\nCOMPLETE AT $(date +%s)" >> $status_log

    # finish the tmp file
    echo "installed" > $installer_status

    # finish
    echo -e "\nPart 5/5 Done! Yaay! Done!\n"

    run_reboot
}

echo -e "\nPrecision Timekeeping Fuckery :3\n"

# do the suto thinggg
# if da file is there
if [ -f $status_log ]; then
    # updoot repo any time the repo is downloaded
    git -C $git_dir pull

    if [[ "$(cat $installer_status)" == 1 ]]; then
        phase_two
    elif [[ "$(cat $installer_status)" == 2 ]]; then
        phase_three
    elif [[ "$(cat $installer_status)" == 3 ]]; then
        phase_four
    elif [[ "$(cat $installer_status)" == 4 ]]; then
        phase_five
    else
        echo -e "\nAlready installed!\n"
        exit
    fi
# if da file is not there
else
    phase_one
fi