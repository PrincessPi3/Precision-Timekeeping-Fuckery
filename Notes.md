# Notes
## Cable Delay
gps cable delay :  RG-85 : 0.051 ns/cm  
10ft in cm: 304.8  
gps cable delay: 304.8*0.051 = 15.5448ns, round up to 16ns  

## pins running
### GPS
#### gps WORKING
yellow - 3.3v - pi physical #17 (3.3)
black - gnd - pi physical #6 (gnd)
white - pps - pi Physical #12 (gpio 18)
blue - rx (module) to tx (pi) pi physical #8 (tx)
green - tx (module) to rx (pi) pi physical #10 (rx)
baud 9600
### RTC
#### i2c rtc WORKING!
red - 3.3v - pi physical #1 (3.3)
black - gnd - pi physical #9 (gnd)
brown - scl - pi physical #5  (i2c clock)
green - sda - pi physical #3 (i2c data)