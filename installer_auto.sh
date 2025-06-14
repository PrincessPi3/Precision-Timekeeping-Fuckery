#!/bin/bash
# usage
##  curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL
set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

echo "Updating Software Lists"
sudo apt update 1>/dev/null 2>&1

echo "Installing git"
sudo apt install git -y 1>/dev/null 2>&1

echo "Cloning Repo"
cd /home/$username
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git
cd /home/$username/Precision-Timekeeping-Fuckery

echo "Stage 1 Complete"
echo "installer_auto.sh complete" > ./status.txt
