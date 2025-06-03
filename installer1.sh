#!/bin/bash
set -e

# updoot this
echo "Updating this repo..."
git pull 1>/dev/null 2>/dev/null

echo "Updating Raspberry Pi firmware..."
sudo rpi-update

# run da raspberry pi config script
echo "Configuring Raspberry Pi..."
sudo raspi-config

echo "Part 1 done!"
echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5