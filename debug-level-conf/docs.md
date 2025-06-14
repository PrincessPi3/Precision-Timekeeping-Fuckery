## Install
1. `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | sudo "$SHELL"`
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
