#!/bin/bash
# usage
## curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | "SHELL"
# set -e

# get real username (not root) if run with sudo
if [ ! -z $SUDO_USER ]; then
    username=$SUDO_USER
else
    username=$USER
fi

# initial delay to make sure its good
echo -e "\nSleeping 3 minutes to make sure everything is as stable as possible\n"
sleep 180

# updoot
echo -e "\nUpdating Software Lists\n"
sudo apt update 

# install get for next step
echo -e "\nInstalling git\n"
sudo apt install -y git

# download da thing
echo "Cloning Repo"
git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git /home/$username/Precision-Timekeeping-Fuckery

# update the log
echo -e "START AT $(date +%s)installer_auto.sh\ncomplete 1/5" >> /home/$username/Precision-Timekeeping-Fuckery/status.txt

# done
echo -e "\nStage 1/5 Complet\n"

# reboot after 3 minutes for safety
echo -e "\nREBOOTING IN 3 MINUTES\n"
sudo shutdown -r +3