#!/bin/bash
set -e

# updoot
echo "Updating software lists..."
sudo apt update 1>/dev/null 2>/dev/null

# updoot this
# echo "Updating this repo..."
# git pull 1>/dev/null 2>/dev/null

# rpi-update
# echo "Updating Raspberry Pi firmware..."
# sudo rpi-update

# run da raspberry pi config script
clear
echo "Configure Raspberry Pi..."
echo -e "Enable I2C Support in raspi-config\n\tInterface Options->I2C->\n\t Would you like the ARM I2C interface to be enabled? <Yes>\n\tkernel module loaded by default <Yes>\n\nInterface Options->Serial Port\n\tWould you like a login shell to be accessible over serial? <No>\n\tWould you like the serial port hardware to be enabled? <Yes>\n"
read -p "Press ENTER to Continue"
sudo raspi-config

echo "Installer1.sh complete" >> ./status.txt

echo "Part 1 done!"
# echo "Rebooting now!"
# sudo reboot
echo "Rebooting in 2 minutes!!"
sudo shutdown -r +2