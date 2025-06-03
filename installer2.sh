#!/bin/bash
set -e

# grafana repo and install
echo "Add Grafana repo"
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# telegraf repo and install
echo "Add Telegraf repo"
curl --silent --location -O \
https://repos.influxdata.com/influxdata-archive.key \
&& echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
| sha256sum -c - && cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null \
&& echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list

# remove dat key file thing
if [ -f ./influxdata-archive.key ]; then
    echo "Removing ./influxdata-archive.key"
    rm -f ./influxdata-archive.key
else
    echo "./influxdata-archive.key not found, skipping delete"
fi

# install em
echo "Getting new software lists"
sudo apt update

echo "Installing packages"
sudo apt install telegraf grafana influxdb pps-tools gpsd gpsd-clients chrony syslog-ng gh lynx btop htop iptraf iotop neovim -y 2>/dev/null

# check if /boot/firmware/config.txt is configured yet
grep -q -e "GPS PPS signals" /boot/firmware/config.txt
grepconfig=$?

# configure the overlay
if [ $grepconfig -eq 0 ]; then
    echo "/boot/firmware/config.txt already updated, skipping"
else
    echo "Adding lines to /boot/firmware/config.txt to enable pps and gpio uart"
    sudo bash -c "echo '# the next 3 lines are for GPS PPS signals' >> /boot/firmware/config.txt"
    sudo bash -c "echo 'dtoverlay=pps-gpio,gpiopin=18' >> /boot/firmware/config.txt"
    sudo bash -c "echo 'enable_uart=1' >> /boot/firmware/config.txt"
    sudo bash -c "echo 'init_uart_baud=115200' >> /boot/firmware/config.txt" # set baudrate here to
fi

# check if pps-gpio is in /etc/modules already
grep -e "pps-gpio" /etc/modules
gerppps=$?

# add pps-gpio to modules
if [ $gerppps -eq 0 ]; then
    echo "pps-gpio already in /etc/modules, skipping"
else
    echo "Adding pps-gpio to modules"
    sudo bash -c "echo 'pps-gpio' >> /etc/modules"
fi

echo "Cleaning up"
sudo apt autoremove # cleanup

echo "Rebooting in 5 minutes"
sudo shutdown -r +5