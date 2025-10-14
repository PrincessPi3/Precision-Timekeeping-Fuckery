#!/bin/bash
# set -e

# grafana repo and install
echo "Add Grafana repo..."
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg 1>/dev/null 2>/dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list 1>/dev/null 2>/dev/null

# telegraf repo and install
echo "Add Telegraf repo..."
curl --silent --location -O \
https://repos.influxdata.com/influxdata-archive.key \
&& echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
| sha256sum -c - && cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg 1>/dev/null 2>/dev/null \
&& echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list 1>/dev/null 2>/dev/null

# remove dat key file thing
if [ -f ./influxdata-archive.key ]; then
    echo "Removing ./influxdata-archive.key..."
    rm -f ./influxdata-archive.key
else
    echo "./influxdata-archive.key not found, skipping delete..."
fi

# updoot
echo "Getting new software lists..."
sudo apt update 

# clean up
echo "Disabling unneeded junk..."
sudo systemctl disable bluetooth 1>/dev/null 2>/dev/null
sudo update-rc.d -f fake-hwclock remove 1>/dev/null 2>/dev/null
sudo systemctl disable fake-hwclock 1>/dev/null 2>/dev/null

echo "Purging unneeded junk..."
sudo apt purge -y "bluetooth*" "usb*" "wireless*" "pci*" "fonts*" "bluez*" "alsa*" fake-hwclock 

# install da packages
echo "Installing packages, this may take a while..."
sudo apt install -y util-linux-extra gawk ripgrep telegraf grafana influxdb  unattended-upgrades net-tools htop btop iptraf iotop screen byobu python3 python3-pip python3-virtualenv python3-setuptools thefuck wget lynx nmap zip unzip 7zip net-tools restic ripgrep pps-tools git gh gpsd gpsd-clients chrony syslog-ng gh lynx btop htop iptraf-ng iotop neovim netcat-traditional python3-smbus i2c-tools picocom

echo "Setting hostname to grandfatherclock"
sudo hostnamectl set-hostname grandfatherclock

# check if pps-gpio is in /etc/modules already
grep -e "pps-gpio" /etc/modules
gerppps=$?

# add pps-gpio to modules
if [ $gerppps -eq 0 ]; then
    echo "pps-gpio already in /etc/modules, skipping..."
else
    echo "Adding pps-gpio to /etc/modules..."
    sudo bash -c "echo 'pps-gpio' >> /etc/modules"
fi

echo "Cleaning up..."
sudo apt autoremove -y 

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# handle users serial shit
## self
echo "Giving $username the right permissions..."
sudo usermod -aG dialout $username
sudo usermod -a -G i2c $username
## service users
echo "Giving service users the right permissions..."
sudo usermod -aG dialout gpsd
sudo usermod -aG dialout _chrony
sudo usermod -aG i2c _chrony
sudo usermod -aG i2c gpsd

echo "installer3.sh complete" >> ./status.txt

echo "Part 3 Done!"
# echo "Rebooting now!"
# sudo reboot
echo "Rebooting in 1 minute!!"
sudo shutdown -r +1