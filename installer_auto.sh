#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo $SHELL
# set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo -e "Edit sudoers file\n\t%sudo ALL = (ALL) NOPASSWD: ALL"
sudo visudo

echo "Updating Software Lists"
sudo apt update 

echo "Installing git"
sudo apt install -y git

echo "Cloning Repo"
cd /home/$username
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git
cd /home/$username/Precision-Timekeeping-Fuckery

echo "Stage 1 Complete"
echo "installer_auto.sh complete" > /home/$username/Precision-Timekeeping-Fuckery/status.txt

echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3