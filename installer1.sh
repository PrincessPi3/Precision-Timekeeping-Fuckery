#!/bin/bash
# set -e

# get real user
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# initial delay to make sure its good
echo "Sleeping 3 minutes"
sleep 180

# rpi-update
echo "Updating Raspberry Pi firmware... DO NOT REBOOT"
sudo rpi-update

# run da raspberry pi config script
clear
echo "Configure Raspberry Pi... DO NOT REBOOT"
echo -e "Enable I2C Support in raspi-config\n\tInterface Options->I2C->\n\t Would you like the ARM I2C interface to be enabled? <Yes>\n\tkernel module loaded by default <Yes>\n\nInterface Options->Serial Port\n\tWould you like a login shell to be accessible over serial? <No>\n\tWould you like the serial port hardware to be enabled? <Yes>\n"
read -p "Press ENTER to Continue"
sudo raspi-config

# update the log
echo "Installer1.sh complete" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

# notify finish
echo "Part 1 Done!"

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3