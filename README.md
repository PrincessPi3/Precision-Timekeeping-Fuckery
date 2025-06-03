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
* `bash ~/Precision-Timekeeping-Fuckert/status_services.sh`

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

## Setup
### Requirements
1. Raspberry Pi with
	1. Raspberry Pi OS Installed
	2. SSH Access
	3. sudo permissions
2. A timing specific GPS module, wired to the Raspberry Pi GPIOs:
	1. GPS GND to RPi pin 6
	2. GPS VIN to RPi pin 2 or 4
	3. GPS PPS to RPi pin 12 (GPIO 18)
	4. GPS RX to RPi pin 8
	5. GPS TX to RPi pin 10

### Install
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
  
check status of everything  
`bash ~/Precision-Timekeeping-Fuckery/full_status.sh`  
  
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
* x ntp server
	* outside dial in
		* cloudflare tunnel?
* change gps settings
	* higher baudrate
		1. 230400
		2. 460800
		3. 921600
* uninstall desktop/etc
	* change boot target to cli
* README
	* installer1-4.sh
		* sudo apt update && sudo apt install git -y
		* git clone https://github.com/PrincessPi3/Precision-Timekeeping-Fuckery.git ~/Precision-Timekeeping-Fuckery
		* cd ~/Precision-Timekeeping-Fuckery
	* grafana
		* url
		* default login
		* import
		* data source
	    * fix
	* Raspberry OS Lite
	* Document scripts
		* chrony_statistics.sh
		* services.sh
		* full_status.sh
		* cleanup.sh
		* dump_configs.sh
		* nuke_logs.sh
		* reconfig_full.sh
	* Remove unneeded services and packages
	* link to docs of all the services and tools
		* influxdb
		* chrony
		* gpsd
		* telegraf
		* garfana
		* syslog-ng
		* u-blox software
		* modules
			* chipset
				* datasheet
			* specific board
				* datasheet

**known bugs**
doubling of appending to /boot/firmaware/config.txt and /etc/modules when running intstaller3.sh

notes:
	reboots
	grafana
		connections->data sources
		add influxdb
		new dashboard
			import
			edit each panel and select influxdb as data source if issues
	doubling of appending to /boot/firmaware/config.txt and /etc/modules