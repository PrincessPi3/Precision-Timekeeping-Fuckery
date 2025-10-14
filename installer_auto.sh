#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo $SHELL
# set -e

# get real username (not root) if run with sudo
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# initial delay to make sure its good
echo "Sleeping 3 minutes"
sleep 180

# passwordless sudo
echo -e "Edit sudoers file\n\t%sudo ALL = (ALL) NOPASSWD: ALL"
sudo visudo

# updoot
echo "Updating Software Lists"
sudo apt update 

# install get for next step
echo "Installing git"
sudo apt install -y git

# download da thing
echo "Cloning Repo"
cd /home/$username
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git

# done
echo "Stage 1 Complete"

# update the log
echo "installer_auto.sh complete" > /home/$username/Precision-Timekeeping-Fuckery/status.txt

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3