# Precision Timekeeping Fuckery

## How it works
### Services
* `gpsd`
* `chrony`
* `telegraf`
* `influxdb`
* `grafana-server`
* `syslog-ng`
  
### Testing
**Status (Everything)**
* `bash ~/Precision-Timekeeping-Fuckery/full_status.sh`
  
**Status (Services)**
* `bash ~/Precision-Timekeeping-Fuckery/status_services.sh`

**Test PPS**
* `sudo ppstest /dev/pps0`
  
### Logs Stuff
**Chrony Logs**  
* `sudo tail -f /var/log/chrony/tracking.log`
* `sudo tail -f /var/log/chrony/statistics.log`
* `sudo tail -f /var/log/chrony/measurements.log`

**Telegraf Logs**  
* `sudo tail -f /var/log/telegraf/telegraf.log`

**Grafana Logs**  
* `sudo tail -f /var/log/grafana/grafana.log`

**Influxdb Logs**  
* `sudo tail -f /var/log/syslog`

**Root Crontab Logs**
* `sudo tail -f /var/log/root-crontab.log`

## Setup
### Requirements
1. Raspberry Pi with
	1. Raspberry Pi OS Light Version Installed
	2. SSH Access
	3. sudo permissions
2. A timing specific GPS module, wired to the Raspberry Pi GPIOs:
	1. GPS GND to RPi Physical Pin 6 (GND)
	2. GPS RX to RPi Physical Pin 8 (GPIO 14 / TX (UART))
	3. GPS TX to RPi Physical Pin 10 (GPIO 15 / RX (UART))
	4. GPS PPS to RPi Physical Pin 12 (GPIO 18)
	5. GPS VIN to RPi Physical Pin 27 (3.3 volts)
3. I2C RTC Module
	1. RTC GND to Rpi Physical Pin 9 (GND)
	3. RTC SDA to RPi Physical Pin 3 (GPIO 2 / SDA1 (I2C))
	4. RTC RCL to RPi Physical Pin 5 (GPIO 4 / SCL1 (I2C))
	5. RTC VCC to RPi Physical Pin 1 (3.3 volts)

### Install
### Hardware
1. pi4/5 and stuff for it
2. gps timing module
3. rtc
4. battery for rtc
5. wires
### Wiring
[Pins and Wiring Guide](./Pins.md)
#### OS
1. Raspberry Pi OS 64 bit lite
   1. Raspberry Pi imager
   2. Configure in imager
      1. hostname: grandmasterclock
      2. enable ssh
      3. ssh key
      4. username
      5. password
      6. locale
      7. keyboard
#### Software (Auto)
**WILL REBOOT IN BETWEEN EACH COMMAND**
1. `curl -s https://raw.githubusercontent.com/PrincessPi3/Precision-Timekeeping-Fuckery/refs/heads/main/installer_auto.sh?nocache=$RANDOM | $SHELL`  
2. `git -C ~/Precision-Timekeeping-Fuckery pull; bash ~/Precision-Timekeeping-Fuckery/installer_auto.sh`
3. `git -C ~/Precision-Timekeeping-Fuckery pull && bash ~/Precision-Timekeeping-Fuckery/installer_auto.sh`
4. `git -C ~/Precision-Timekeeping-Fuckery pull && bash ~/Precision-Timekeeping-Fuckery/installer_auto.sh`
5. `git -C ~/Precision-Timekeeping-Fuckery pull && bash ~/Precision-Timekeeping-Fuckery/installer_auto.sh`
6. `git -C ~/Precision-Timekeeping-Fuckery pull && bash ~/Precision-Timekeeping-Fuckery/test.sh`
#### Software (Manual)
Clone the repo  
`git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git ~/Precision-Timekeping-Fuckery`  
  
Run raspi-config
1. Interface Options->Serial Port
	1. Would you like a login shell to be accessible over serial? **<No>**
	2. Would you like the serial port hardware to be enabled? **<Yes>**
2. Advanced Options
		1. A1 Expand Filesystem

update os and packages (will reboot when finished)  
`bash ~/Precision-Timekeeping-Fuckery/update.sh`  
  
install packages (will reboot when finished)  
`bash ~/Precision-Timekeeping-Fuckery/packages.sh`  
  
finish install (will reboot when finished)  
`bash ~/Precision-Timekeeping-Fuckery/installer.sh`  
  
check status of everything and test
`bash ~/Precision-Timekeeping-Fuckery/test.sh`  
  
navigate to `http://<ip's ip>:3000`  
Upload ~/Garfana-Visualization.json to create dashboard

### Clients
**Windows**
1. Open the Control Panel and navigate to the Date and Time settings.
2. Click on "Internet Time" and then "Change settings".
3. Enable the option to "Synchronize with an Internet time server".
4. Choose a time server from the available list or enter a custom one.
5. Click "OK" to save the changes. 

## Links
**Helpful Guide** https://austinsnerdythings.com/2025/02/14/revisiting-microsecond-accurate-ntp-for-raspberry-pi-with-gps-pps-in-2025/  

**Current Module**
* Chipset https://www.u-blox.com/en/product/neo-f10n-module
* Breakout https://docs.sparkfun.com/SparkFun_u-blox_NEO-F10N/single_page/  

**Next Module**
* Chipset https://www.u-blox.com/en/product/neolea-m8t-series
* Breakout https://www.ebay.com/itm/134243322249

**U-Blox Software (U-Center)**  https://www.u-blox.com/en/product/u-center
  
  
**todo**
* case
* gps sma antenna adaptor
* change gps settings
	* use 5v
	* adjust time delay to be closer to
	* higher baudrate
		1. 460800
* README
	* installer1-4.sh
		* sudo apt update && sudo apt install -y git
		* git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git ~/Precision-Timekeeping-Fuckery
		* cd ~/Precision-Timekeeping-Fuckery
	* grafana
		* url
		* default login
		* import
		* data source
	    * fix
		* current
			* connections->data sources->add data source->influxdb
				* url http://127.0.0.1:8086
				* timeout 5
				* database Chrony_Stats
				* save and test
				* new dashboard
				* import a dashbboard->Garfana-Visualization.json
				* edit and update each pannel
				* save dashboard
* Raspberry OS Lite
* Document scripts
	* chrony_statistics.sh
	* services.sh
	* test.sh
	* cleanup.sh
	* dump_configs.sh
	* nuke_logs.sh
	* reconfig_full.sh
* link to docs of all the services and tools
	* influxdb
	* chrony
	* gpsd
	* telegraf
	* garfana
	* syslog-ng
	* u-blox software
	* modules
		* chipsets
			* datasheet
		* specific boards
			* datasheet
* installer with reboot cron for sequence?


notes:
gps cable delay :  RG-85 : 0.051 ns/cm
10ft in cm: 304.8
gps cable delay: 304.8*0.051 = 15.5448ns, round up to 16ns


**known bugs**
