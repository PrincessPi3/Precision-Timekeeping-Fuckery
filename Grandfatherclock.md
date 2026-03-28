# Version 3:

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
    9.  Any pulse out (32kHz maybe?)
2.  [Pulsar Clock](Pulsar-Clock.md)
    1.  all daaat shit lmao

## Hardware

1.  Raspberry Pi 5 16GB
    
    1.  Raspberry OS Lite
        
    2.  Will need to carefully use real time priority, maybe even pinned to a core?
        
```bash
sudo taskset -cp 2 1234 # set task pid 1234 pin to core 2
```
            
```bash
sudo chrt -f -p 90 1234 # set pid 1234 to priority 90 (1-99  highest)
```         
1.  RTC 32khz pulses
2.  pulsar readings
3.  RTC set/read
4.  GPS Module PPS
    1.  gpsd, etc?
5.  NVME hat for NVME boot (? IF NOT INTERFERE WITH GPIO SHIT)
    
    1.  NVME SSD (? IF NOT INTERFERE WITH GPIO SHIT)
6.  **Custom Hat**
    
    1.  1.  [RTC](https://www.adafruit.com/product/3013#tutorials) x2
            
            1.  [CR1220](https://www.adafruit.com/products/380) x2 (Battery)
        1.  Gen 10 Timekeeping Specific GPS Module - NEO-F10T
            
            1.  &nbsp;[Buy Varieties (Europe)](https://gnss.store/collections/neo-f10t-timing-gnss-modules)
                
                1.  Make sure battery TYPE and APPLICATION is figured out
                    1.  May have to solder in holder or something
                2.  Make sure GPIO pins are FUCKING 2.54mm AND 3.3v OR 5v
                    1.  use goldddd ones~
                3.  Make sure antenna connector is gonna work
                    1.  GPS cable
                    2.  GPS antenna
            2.  [Product Summary](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_ProductSummary_UBX-22025534.pdf)
                
            3.  [Data Sheet](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_DataSheet_UBX-22022576.pdf)
                
            4.  [Hardware Integration Guide](https://content.u-blox.com/sites/default/files/documents/NEO-F10T_IntegrationManual_UBX-22018271.pdf)
                
            5.  [Chip Product Page](https://www.u-blox.com/en/product/neo-f10t-module)
                

## Operation Flow

Both RTCs loaded time over I2C, both inputting 32kHz signal via GPIO

Dual RTC time, GPS time, system time, GPS PPS, dual 32kHz signals, pulsar readings:

- tested off each other
    - deltas per pulse (errors) (add to Grafana)
    - averages per pulse (add to Grafana)
    - stored in histograms, constantly updating (add to Grafana)
        - dial in desired confidence interval over time (add to Grafana)
    - divisor/multiplier for 32kHz pulses to make them ONE BEAT constantly updated (displayed in Grafana)
        - one 32kHz oscillator (the most reliable) will be dubbed the "master universal beat pulse", made into pulse by divisor/multiplier based on previous calculations
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
    

&nbsp;