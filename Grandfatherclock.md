# Version 3

## To Figure Out

1.  Details on the NEO-F10T/breakout
    1.  Battery
    2.  GPIO Pinouts
    3.  Voltages
    4.  GPIO pin pitch
    5.  Antenna connector type
    6.  Best GPS Antenna+Cable for it
    7.  PPS Settings
    8.  UART Speed settings
2. RPI5
	1. pulse out/in (32kHz 31.25us period/10mhz 1ns period?)
3.  [Pulsar Clock](Pulsar-Clock.md)
    1.  all daaat shit lmao
## Hardware
1.  [Raspberry Pi 5 16GB](https://www.adafruit.com/product/6125)
    1.  Raspberry OS Lite
    2.  Will need to carefully use real time priority, maybe even pinned to a core?
	    1.  gpsd, etc?
	    2.  Reading GPIO Pulses/etc
	    3.  UART?
```bash
sudo taskset -cp 2 1234 # set task pid 1234 pin to core 2
```

```bash
sudo chrt -f -p 90 1234 # set pid 1234 to priority 90 (1-99  highest)
```

1.  RTC 32khz pulses (31.25us period)
2.  Pulsar readings
3.  RTC set/read over i2c
4.  GPS Module PPS
5.  NVME hat for NVME boot (? IF NOT INTERFERE WITH GPIO SHIT)
    1.  NVME SSD (? IF NOT INTERFERE WITH GPIO SHIT)
6.  **Custom Hat**
    1.  [Adafruit DS3231 RTC Precision I2C Breakout Module](https://www.adafruit.com/product/3013#tutorials) x1  
        [CR1220](https://www.adafruit.com/products/380) x1 (Battery)
7.  [Gen 10 Timekeeping Specific GPS Module - NEO-F10T](https://gnss.store/collections/neo-f10t-timing-gnss-modules)
    
    1.  &nbsp;
        
8.  GPS Module
	1.  [Buy Varieties (Europe)](https://gnss.store/collections/neo-f10t-timing-gnss-modules)
        1.  Make sure **BATTERY** **TYPE** and **APPLICATION** is figured out 
        2.  May have to solder in holder or something
			1.  use the good solder/pins/wire :3
		 3.  Make fuckin sure af you have a good fuckin pinout
		 4.  check if can be configed via uart using [u-center-2](https://www.u-blox.com/en/u-center-2)?
			 1.  figure out a convenient UART (Tigard/FT422H) and plug
		2.  Make sure GPIO pins are FUCKING **2.54mm** AND **3.3v** OR **5v**
		    1. use good/gold/copper pinssss/wire/solder
	9. [Gen 10 Timekeeping Specific GPS Module - NEO-F10T](https://gnss.store/collections/neo-f10t-timing-gnss-modules)
    10.  [Product Summary](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_ProductSummary_UBX-22025534.pdf)
    11.  [Data Sheet](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_DataSheet_UBX-22022576.pdf)
    12.  [Hardware Integration Guide](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_IntegrationManual_UBX-22018271.pdf)
    13.  [Chip Product Page](https://www.u-blox.com/en/product/neo-f10t-module)

9.  GPS cable
    1.  check connectors
    2.  check adaptors
    3.  check variety
        1.  speed/length
        2.  check length
10.  GPS antenna
    1.  check protos
    2.  check bands
    3.  check features
    4.  check connectors
## RPI5 Wiring
- [GPIO Simple Pinout](https://vilros.com/pages/raspberry-pi-5-pinout)
- [GPIO Detailed Pinout](https://pinout.xyz/pinout/3v3_power)
### Wiring of Note
- CLK/PCM/GPIO18/PIN12:
    - CLK in/out up to 10mHz (1ns period)
    - ![9824306b308e6d2d21274a5bfe933c6b.png](../../_resources/9824306b308e6d2d21274a5bfe933c6b-1.png)
    - only one i2c port?
    - mostly all 3v3?
    - PCM is kinda like DAC?
    - GPIO Read?
    - PWM?
    - find sum DAC/ADC? sumtin?
    - **May have to nix double RTC Module**
### Wiring
- UART (GPS Module, tinker with speed)
- I2C (RTC)
- CLK/PCM/GPIO READ? (RTC 32khz pulse - 31.25us period)
## Operation Flow
Both RTCs loaded time over I2C, both inputting 32kHz (31.25us period) signal via GPIO

RTC time, GPS time, system time, GPS PPS, 32kHz (31.25us period) signal, pulsar readings:

- tested off each other
    - deltas per pulse (errors) (add to Grafana)
    - averages per pulse (add to Grafana)
    - stored in histograms, constantly updating (add to Grafana)
        - dial in desired confidence interval over time (add to Grafana)
    - divisor/multiplier for 32kHz pulses to make them ONE BEAT constantly updated (displayed in Grafana)
        - 32kHz oscillator (31.25us period) (or most reliable) will be dubbed the "master universal beat pulse", made into pulse by divisor/multiplier based on previous calculations
        - and will serve as source of truth for UBT web display
- sanity tested against network sources

1.  Test both RTC times against GPS time
2.  Test system time against GPS time
3.  Test system time against network time
4.  Sanity Checks
    1.  Time reported vs time actual (net)
    2.  Cable/system delay calculated vs delay measured
    3.  Readability check
    4.  Repeatability check
    5.  Accuracy check
    6.  Precision check
## Maybe
1.  Play with PPS (dial faster?)
2.  Play with UART speed (dial faster?)
3.  tinker with 10mhz clock out/test/tinker
4.  tinker with 32khz clock in/test/tinker