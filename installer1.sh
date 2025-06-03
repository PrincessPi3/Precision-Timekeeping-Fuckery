#!/bin/bash
set -e

# updoot this
git pull

# updoot
sudo apt update
sudo apt dist-upgrade -y
sudo apt autoremove

sudo shutdown -r +1