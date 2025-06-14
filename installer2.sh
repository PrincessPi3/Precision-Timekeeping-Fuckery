#!/bin/bash
set -e

echo "Fully upgrading, this may take a while..."
sudo apt dist-upgrade -y > /dev/null

echo "Cleaning up..."
sudo apt autoremove -y > /dev/null

echo "Installer2.sh complete" >> ./status.txt

echo "Part 2 done!"
echo "Rebooting now!"
sudo reboot
echo "Rebooting in 1 minute!"
sudo shutdown -r +1