#!/bin/bash
set -e

# updoot this
echo "Updating this repo..."
git pull 1>/dev/null

sudo rpi-update

# run da raspberry pi config script
sudo raspi-config

echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5