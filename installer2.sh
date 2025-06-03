#!/bin/bash
set -e

# updoot
echo "Updating software lists..."
sudo apt update 1>/dev/null 2>/dev/null

echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y 1>/dev/null 2>/dev/null

echo "Cleaning up..."
sudo apt autoremove -y 1>/dev/null 2>/dev/null

echo "Rebooting now!"
sudo reboot
# sudo shutdown -r +5