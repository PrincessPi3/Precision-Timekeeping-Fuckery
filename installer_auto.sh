#!/bin/bash
# usage
##  curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo $SHELL
set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo "Updating Software Lists"
sudo apt update

echo "Installing git"
sudo apt install git -y

echo "Cloning Repo"
cd /home/$username
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git
cd /home/$username/Precision-Timekeeping-Fuckery

echo "Fixing Permissions on Repo"
sudo chown $username:$username -R /home/$username/Precision-Timekeeping-Fuckery

echo "Done!"
echo "installer_auto.sh complete" > ./status.txt
