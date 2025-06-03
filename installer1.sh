#!/bin/bash
set -e

# updoot this
echo "Updating this repo"
git pull

# updoot
echo "Updating software lists"
sudo apt update

echo "Fully upgrading"
sudo apt dist-upgrade -y

echo "Cleaning up"
sudo apt autoremove

echo "Rebooting in 5 minutes"
sudo shutdown -r +5