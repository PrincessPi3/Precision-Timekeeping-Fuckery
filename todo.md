**todo**
* case
* Raspberry OS Lite
* Document scripts
  * time_fuckery.sh [test]
  * show_running_configs.sh
  * services.sh [start|stop|restart|enable|disable]
  * uninstall.sh
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
* figure out multiple network time servers that support iburst NTS
    * fiugre out what this means
        * server nts.anastrophe.com iburst nts maxsamples 1
    https://gist.github.com/jauderho/2ad0d441760fc5ed69d8d4e2d6b35f8d
* fiugre out/test pps1 and pps0
* find the proper datasheet not just the F9T one
* documentation
* case
* positioning
    * traffic
    * power
    * temperature
* backups
    * restic backups
    * backup image 
* check wiring
* check antenna tight both ends
* make image backup