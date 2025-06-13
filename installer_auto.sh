#!/bin/bash
# usage
##  curl https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh | sudo $SHELL
set -e

if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

sudo apt update
sudo apt install git -y
cd /home/$username
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git
cd /home/$username/Precision-Timekeeping-Fuckery
bash installer1.sh