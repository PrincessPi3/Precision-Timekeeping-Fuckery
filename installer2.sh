#!/bin/bash
# set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y 1>/dev/null 

echo "Cleaning up..."
sudo apt autoremove -y 1>/dev/null 

echo "Installer2.sh complete" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

echo "Part 2 Done!"
# echo "Rebooting now!"
# sudo reboot
echo "Rebooting in 1 minute!"
sudo shutdown -r +1