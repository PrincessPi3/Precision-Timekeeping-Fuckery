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

# full distribution upgrade
echo -e "\nFully upgrading, this may take a while...\n"
sudo apt dist-upgrade -y

# safety delay
echo -e "\nSleeping 60 seconds to make sure its as stable as possible\n"
sleep 60

# cleanup
echo -e "\nCleaning up...\n"
sudo apt autoremove -y

# notify finish
echo -e "\nPart 3/5 Done!\n"

# update the log
echo "Installer2.sh complete 3/5" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3