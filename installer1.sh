#!/bin/bash
# updoot this
echo "Updating this repo"
git pull 2>/dev/null 1>/dev/null

# run da raspberry pi config script
sudo raspi-config

echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5