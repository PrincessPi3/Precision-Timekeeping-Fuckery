#!/bin/bash
set -e

# updoot
echo "Updating software lists"
sudo apt update

echo "Fully upgrading"
sudo apt dist-upgrade -y

echo "Cleaning up"
sudo apt autoremove

echo "Rebooting in 5 minutes"
sudo reboot
# sudo shutdown -r +5