## Install
1. `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo $SHELL`
3. `bash ~/Precision-Timekeeping-Fuckery/installer1.sh` (will reboot)
5. `bash ~/Precision-Timekeeping-Fuckery/installer2.sh` (will reboot)
6. `bash ~/Precision-Timekeeping-Fuckery/installer3.sh` (will reboot)
7. `bash ~/Precision-Timekeeping-Fuckery/installer4.sh` (will reboot)
8. grafana
    1. pull up grafana web interface in a browser: `http://<ip>:3000`
    2. username `admin` password `admin`
    3. Dashboards->Import
        1. Upload Garfana-Visualization.json
    4. edit each graph and just save
9. after 24 hours
    1. `cd ~/Precision-Timekeeping-Fuckery`
    1. `bash reconfig_full.sh ./running-warn-level-conf` (will reboot)

## Scripts
`uninstall.sh` uninstalls everything
`chrony_statistics.sh` uses the python script chrony_statistics.py and feeds it copies of tracking statistics to calculate offset
`cleanup.sh` remove old files 
`dump_configs.sh` make a backup of all configs
`full_status.sh` show status of all of the componants of Precision-Timekeeping-Fuckery one by one
`installer_auto.sh` script to initialize the install, it is run first
* usage: `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo $SHELL`
`installer1.sh` first manual installer script. runs rpi-config and optionall rpi-update
`installer2.sh` second manual installer script. performs a dist-upgrade and an autoremove
`installer3.sh` third manual installer script. adds grafana and telegram repos, uninstalls and disables unneeded junk, installs packages, adds pps-gpio to /etc/modules if not there, autoremove, gives users the right groups
`installer4.sh` final manual installer script. runs `reconfig_full.sh` and enables the services on boot
`nuke_logs.sh` does just what it says on the tin
`reconfig_full.sh` reconfigures services in one of the directories
* usage: `bash reconfig_full <config_directory>`
`services.sh` runs an operation on all of the relevant services
* usage: `bash services.sh [start|status|stop|restart|reload|enable|disable]`
`show_running_configs.sh` shows the current config files, one by one