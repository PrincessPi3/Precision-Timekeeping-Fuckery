#!/bin/bash
set -e

echo "Updating this repo..."
git pull 1>/dev/null 2>/dev/null

# updoot
echo "Updating software lists..."
sudo apt update 1>/dev/null 2>/dev/null

echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y

echo "Cleaning up..."
sudo apt autoremove -y

echo "Part 2 done!"
# echo "Rebooting now!"
# sudo reboot
echo "Rebooting in 2 minutes!!"
sudo shutdown -r +2