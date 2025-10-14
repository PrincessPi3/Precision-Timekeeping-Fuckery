#!/bin/bash
# set -e

# get real user
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# initial delay to make sure its good
echo -e "\nSleeping 3 minutes to make sure everything is as stable as possible\n"
sleep 180

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
sleep 60

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
sleep 60

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
sleep 60

# installing ble.sh
echo -e "\nInstalling BLE.sh\n"
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
make -C /tmp/ble.sh install PREFIX=/home/$username/.local
echo -e "\n# ble.sh" >> /home/$username/.bashrc
echo "source -- /home/$username/.local/share/blesh/ble.sh" >> /home/$username/.bashrc

# safety delay
echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
sleep 60

# general-scripts-and-system-ssssssetup
echo -e "\nInstalling general-scripts-and-system-ssssssetup\n"
curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh?nocache=$RANDOM | sudo "$SHELL"

# update the log
echo "installer3.sh complete 4/5" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

# finish
echo -e "\nPart 4/5 Done\n!"

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3