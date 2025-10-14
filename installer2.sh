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

# full distribution upgrade
echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y

# cleanup
echo "Cleaning up..."
sudo apt autoremove -y

# notify finish
echo "Part 2 Done!"

# update the log
echo "Installer2.sh complete" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3