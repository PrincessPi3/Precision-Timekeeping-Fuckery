## Install
### Hardware Needed
1. Raspberry Pi of any type
2. Timing Specific GPS Module [U-BLOX ublox LEA-M8T-0-10 HUAWEI GPS Module](https://www.ebay.com/itm/134243322249)
3. High Precision RTC Module like [Adafruit DS3231 Precision RTC Breakout](https://www.adafruit.com/product/3013)
4. CR1220 Battery for RTC
5. Female to Female jumper/dupont wires
6. Raspberry Pi Case that Exposes GPIO
7. (GPS Antenna)[https://www.aliexpress.us/item/3256808971033962.html]
8. (Cable for GPS Antenna)[https://www.amazon.com/Superbat-coaxial-Bulkhead-Adapter-Equipment/dp/B07FC8PVZS?th=1]
9. (GPS Antenna Adaptor)[https://www.amazon.com/dp/B00CVR4NN0]
10. UART
11. Solder Supplies (maybe)

### Configuring Hardware
1. Install (u-center)[https://www.u-blox.com/en/product/u-center] NOT u-center 2
2. Wire UART of GPS Module to your UART
    1. Change baudrate to 115200

### Wiring Everything Up
#### GPS Module
1. GPS GND to RPi Physical Pin 6 (GND)
2. GPS RX to RPi Physical Pin 8 (GPIO 14 / TX (UART))
3. GPS TX to RPi Physical Pin 10 (GPIO 15 / RX (UART))
4. GPS PPS to RPi Physical Pin 12 (GPIO 18)
5. GPS VIN to RPi Physical Pin 27 (3.3 volts)
#### RTC Module
1. RTC GND to Rpi Physical Pin 9 (GND)
3. RTC SDA to RPi Physical Pin 3 (GPIO 2 / SDA1 (I2C))
4. RTC RCL to RPi Physical Pin 5 (GPIO 4 / SCL1 (I2C))
5. RTC VCC to RPi Physical Pin 1 (3.3 volts)

### Setup Pi
#### Microsd Card
1. Install [Raspberry Pi Imager](https://www.raspberrypi.com/software/) on your PC
2. Insert Microsd card to your PC
3. Run Raspberry Pi Imager
    1. Choose Device (your Raspberry Pi Type)
    2. Choose OS->Raspberry Pi OS (other)->Raspberry Pi OS Lite (64-bit)
    3. Choose Storage (your Microsd card)
    4. Configure settings as you like them
    5. Burn
#### Login to Raspberry Pi
1. `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL`
2. `cd ~/Precision-Timekeeping-Fuckery && bash installer1.sh` (will )
3. `cd ~/Precision-Timekeeping-Fuckery && bash installer2.sh` (will reboot)
4. `cd ~/Precision-Timekeeping-Fuckery && bash installer3.sh` (will reboot)
5. `cd ~/Precision-Timekeeping-Fuckery && bash installer4.sh` (will reboot)
6. `curl -s https://gitlab.com/princesspi/general-scripts-and-system-ssssssetup/-/raw/master/customscripts/install_script.sh?nocache=$RANDOM | sudo $SHELL`
7. `exec $SHELL`
8. Grafana
    1. open grafana web interface in a browser: `http://<ip>:3000`
    2. username `admin` password `admin`
    3. set new password
    4. Dashboards->Import
        1. Upload Garfana-Visualization.json
    5. edit each graph and just save
9. After 24 Hours
    1. `cd ~/Precision-Timekeeping-Fuckery`
    2. `bash services.sh stop`
    3. `bash nuke_logs.sh`
    4. `bash reconfig_full.sh ./running-warn-level-conf`
    5. `sudo reboot`

## Scripts
* `uninstall.sh` uninstalls everything
* `chrony_statistics.sh` uses the python script chrony_statistics.py and feeds it copies of tracking statistics to calculate offset
*`cleanup.sh` remove old files 
* `dump_configs.sh` make a backup of all configs
* `full_status.sh` show status of all of the componants of Precision-Timekeeping-Fuckery one by one
* `installer_auto.sh` script to initialize the install, it is run first
    * usage: `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL`
* `installer1.sh` first manual installer script. runs rpi-config and optionall rpi-update
* `installer2.sh` second manual installer script. performs a dist-upgrade and an autoremove
* `installer3.sh` third manual installer script. adds grafana and telegram repos, uninstalls and disables unneeded junk, installs packages, adds pps-gpio to /etc/modules if not there, autoremove, gives users the right groups
* `installer4.sh` final manual installer script. runs `reconfig_full.sh` and enables the services on boot
* `nuke_logs.sh` does just what it says on the tin
* `reconfig_full.sh` reconfigures services in one of the directories
    * usage: `bash reconfig_full.sh <config_directory>`
* `services.sh` runs an operation on all of the relevant services
    * usage: `bash services.sh [start|status|stop|restart|reload|enable|disable]`
* `show_running_configs.sh` shows the current config files, one by one
* `cable-delay-calc.xlsx` spreadsheet to estimate cable delay in ns

## Files
* `status.txt` this shows the progress of an ongoing install, it is automatically created at the start and deleted at the end
* `CHANGEOG.txt` this is all the latest changes
* `version.txt` version of Precision-Timekeeping-Fuckery

## Logs
### Chrony Logs
* `sudo tail -f /var/log/chrony/tracking.log`
* `sudo tail -f /var/log/chrony/statistics.log`
* `sudo tail -f /var/log/chrony/measurements.log`
### Telegraf Logs
* `sudo tail -f /var/log/telegraf/telegraf.log`
### Grafana Logs 
* `sudo tail -f /var/log/grafana/grafana.log`
### Influxdb Logs
* `sudo tail -f /var/log/syslog`
### Root Crontab Logs
* `sudo tail -f /var/log/root-crontab.log`