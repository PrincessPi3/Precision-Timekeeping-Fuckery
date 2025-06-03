#!/bin/bash
# updoot this
echo "Updating this repo"
git pull

# run da raspberry pi config script
sudo raspi-config

echo "Rebooting in 5 minutes"
sudo shutdown -r +5