#!/bin/bash
set -e

# sudo apt update

# change boot target to cli before deleting desktop environ
# sudo systemctl set-default multi-user.target

# nuke old packages
# sudo apt purge cups cups-browsed pulseaudio* bluetooth libgl* xserver* lightdm* raspberrypi-ui-mods vlc* lxde* chromium* desktop* gnome* gstreamer* gtk* hicolor-icon-theme* lx* mesa* -y

# sudo apt dist-upgrade -y

# install packages
sudo apt install influxdb pps-tools gpsd gpsd-clients chrony syslog-ng -y

# grafana repo and install
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# telegraf repo and install
curl --silent --location -O \
https://repos.influxdata.com/influxdata-archive.key \
&& echo "943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515  influxdata-archive.key" \
| sha256sum -c - && cat influxdata-archive.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null \
&& echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list

sudo apt update
sudo apt install telegraf grafana -y

sudo apt autoremove # cleanup

sudo reboot