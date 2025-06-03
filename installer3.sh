#!/bin/bash
set -e # die on any error

# configure the overlay
echo "Adding lines to /boot/firmware/config.txt to enable pps and gpio uart"
sudo bash -c "echo '# the next 3 lines are for GPS PPS signals' >> /boot/firmware/config.txt"
sudo bash -c "echo 'dtoverlay=pps-gpio,gpiopin=18' >> /boot/firmware/config.txt"
sudo bash -c "echo 'enable_uart=1' >> /boot/firmware/config.txt"
sudo bash -c "echo 'init_uart_baud=115200' >> /boot/firmware/config.txt" # set baudrate here too

# add pps-gpio to modules
echo "Adding pps-gpio to modules"
sudo bash -c "echo 'pps-gpio' >> /etc/modules"

sudo shutdown -r +1