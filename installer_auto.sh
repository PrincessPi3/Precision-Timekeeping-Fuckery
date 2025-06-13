#!/bin/bash
# usage
##  curl https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh | sudo $SHELL
set -e
sudo apt update
sudo apt install git -y
cd $HOME
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git
cd Precision-Timekeeping-Fuckery
bash installer1.sh