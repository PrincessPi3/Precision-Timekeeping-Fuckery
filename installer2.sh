#!/bin/bash
# set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y

echo "Cleaning up..."
sudo apt autoremove -y

echo "Installer2.sh complete" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

echo "Part 2 Done!"
# echo "Rebooting now!"
# sudo reboot
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3