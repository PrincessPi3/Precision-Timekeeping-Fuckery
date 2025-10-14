#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | "$SHELL"

# explicitly die on any error
set -e

# delays in minutes
long_delay=3
short_delay=1

# first install
first_install="git"

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

phase_one () {
    # initial delay to make sure its good
    echo -e "\nSleeping $long_delay minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds

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

    # reboot after 3 minutes for safety
    echo -e "\nREBOOTING IN 3 MINUTES\n"
    sudo shutdown -r +$long_delay
}

phase_two () {
    # initial delay to make sure its good
    echo -e "\nSleeping 3 minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds

    # rpi-update
    echo -e "\nUpdating Raspberry Pi firmware... DO NOT REBOOT\n"
    sudo rpi-update

    # safety delay
    echo -e "\nSleeping $short_delay_seconds seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # run da raspberry pi config script
    clear
    echo -e "\nConfigure Raspberry Pi... DO NOT REBOOT\n"
    echo -e "Enable I2C Support in raspi-config\n\tInterface Options->I2C->\n\t Would you like the ARM I2C interface to be enabled? <Yes>\n\tkernel module loaded by default <Yes>\n\nInterface Options->Serial Port\n\tWould you like a login shell to be accessible over serial? <No>\n\tWould you like the serial port hardware to be enabled? <Yes>\n"
    read -p "Press ENTER to Continue"
    sudo raspi-config

    # notify finish
    echo -e "\nPart 2/5 Done!\n"

    # update the running file
    echo 2 > $installer_status

    # update the log
    echo "installer1.sh complete 2/5" >> $status_log

    # reboot after 3 minutes for safety
    echo -e "\nREBOOTING IN 3 MINUTES\n"
    sudo shutdown -r +$long_delay
}

phase_three () {
    # initial delay to make sure its good
    echo -e "\nSleeping $long_delay minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds

    # full distribution upgrade
    echo -e "\nFully upgrading, this may take a while...\n"
    sudo apt dist-upgrade -y

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # cleanup
    echo -e "\nCleaning up...\n"
    sudo apt autoremove -y

    # update the running file
    echo 3 > $installer_status

    # notify finish
    echo -e "\nPart 3/5 Done!\n"

    # update the log
    echo "Installer2.sh complete 3/5" >> $status_log

    # reboot after 3 minutes for safety
    echo -e "\nREBOOTING IN 3 MINUTES\n"
    sudo shutdown -r +$long_delay
}

phase_four () {
    # initial delay to make sure its good
    echo -e "\nSleeping 3 minutes to make sure everything is as stable as possible\n"
    sleep $long_delay_seconds

    # grafana repo and install
    echo -e "\nAdd Grafana repo...\n"
    sudo mkdir -p /etc/apt/keyrings/
    wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

    # telegraf repo and install
    echo -e "\nAdd Telegraf repo...\n"
    curl --silent --location -O \
    https://repos.influxdata.com/influxdata-archive.key \
    && echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
    | sha256sum -c - && cat influxdata-archive.key \
    | gpg --dearmor \
    | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg \
    && echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
    | sudo tee /etc/apt/sources.list.d/influxdata.list >/dev/null # otherwisse get some stupid binary output to terminal

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

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possibl\n"
    sleep $short_delay_seconds

    # clean up
    echo -e "\nDisabling unneeded junk..\n"
    sudo systemctl disable bluetooth
    sudo update-rc.d -f fake-hwclock remove
    # sudo systemctl disable fake-hwclock

    # install da packages
    echo -e "\nInstalling packages, this may take a while...\n"
    sudo apt install -y util-linux gawk telegraf grafana influxdb restic build-essential net-tools htop btop screen byobu python3 python3-pip python3-virtualenv python3-setuptools thefuck wget lynx nmap zip unzip 7zip ripgrep pps-tools gh gpsd gpsd-clients chrony syslog-ng iptraf-ng i2c-tools picocom

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # purging da junk
    # dont actually think this is at worth the space savings
    # echo "Purging unneeded junk..."
    # sudo apt purge -y "bluetooth*" "usb*" "wireless*" "pci*" "fonts*" "bluez*" "alsa*"

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

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # installing ble.sh
    echo -e "\nInstalling BLE.sh\n"
    bashrc="/home/$username/.bashrc"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX=/home/$username/.local
    echo -e "\n# ble.sh" >> $bashrc
    echo "source -- /home/$username/.local/share/blesh/ble.sh" >> $bashrc

    # safety delay
    echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
    sleep $short_delay_seconds

    # general-scripts-and-system-ssssssetup
    echo -e "\nInstalling general-scripts-and-system-ssssssetup\n"
    curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh?nocache=$RANDOM | sudo "$SHELL"

    # update the running file
    echo 4 > $installer_status

    # update the log
    echo "installer3.sh complete 4/5" >> $status_log

    # finish
    echo -e "\nPart 4/5 Done\n!"

    # reboot after 3 minutes for safety
    echo -e "\nREBOOTING IN 3 MINUTES\n"
    sudo shutdown -r +$long_delay
}

phase_five () {
    # initial delay to make sure its good
    echo -e "\nSleeping $long_delay minutes\n"
    sleep $long_delay_seconds

    # reconfigure to normal mode
    echo -e "\nStarting configure script...\n"
    # info level
    # bash ./reconfig_full.sh ./reconfig_full.sh ./info-level-conf
    # running (warn level) 
    # bash ./reconfig_full.sh ./running-warn-level-conf
    # debug/dev mode
    bash $git_dir/reconfig_full.sh "$git_dir/info-level-conf-huawaii"

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

    # delete tmp file
    rm -f $status_log

    # finish
    echo -e "\nPart 5/5 Done! Yaay! Done!\n"

    # reboot after 3 minutes for safety
    echo -e "\nREBOOTING IN $long_delay MINUTES\n"
    sudo shutdown -r +$long_delay
}

# do the suto thinggg
if [ -f $status_log ]; then
    if [[ $(cat $installer_status) =~ "*1*"  ]]; then
        phase_two
    elif [[ $(cat $installer_status) =~ "*2*"  ]]; then
        phase_three
    elif [[ $(cat $installer_status) =~ "*3*"  ]]; then
        phase_four
    elif [[ $(cat $installer_status) =~ "*4*"  ]]; then
        phase_five
    fi
else
    phase_one
fi