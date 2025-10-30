# Pins
## U-BLOX LEA-M8T-0-10 HUAWEI GPS Module
**Pins are 2mm pitch**
**3.3 Volts**
| Cable  | Module Pin | Module Pin Meaning   | Pi Pin (Physical) | Pi Pin (Name) | Voltage     | Notes                          |
|:-------|:-----------|:---------------------|:------------------|:------------------|:--------|:-------------------------------|
| Yellow | 2          | Voltage In           | 17                | 3.3 Volts         | 3.3 V   | NOT 5 V TOLERANT               |
| Black  | 8          | Ground               | 6                 | GND               | 3.3 V?  | UNKNOWN 3 V AND 5 V TOLERANCES |
| White  | 6          | Time Pulse 1/PPS     | 12                | GPIO 18           | 3.3 V   | NOT 5 V TOLERANT               |
| Blue   | 5          | UART RX              | 8                 | UART TX / GPIO 14 | 3.3 V   | NOT 5 V TOLERANT               |
| Green  | 3          | UART TX              | 10                | UARD RX / GPUI 15 | 3.3 V   | NOT 5 V TOLERANT               |
## Adafruit DS3231 Precision RTC Breakout
**Pins are 2.54mm pitch**
**3.3 Volts**
| Cable | Module Pin (Physical) | Module Pin (Name) | Pi Pin (Physical) | Pi Pin (Name) | Voltage | Notes           |
|:------|:----------------------|:------------------|:------------------|------------   |:--------|:----------------|
| Red   | 1                     | Voltage In        | 1                 | 3.3 Volts     | 3.3 V   | NOT 5V TOLERANT |
| Black | 9                     | Ground            | 9                 | GND           | 3.3 V   | NOT 5V TOLERANT |
| Brown | 3                     | SCL1 / I2C Clock  | 5                 | GPIO 4 / SCL1 | 3.3 V   | NOT 5V TOLERANT |
| Green | 4                     | SDA1 / I2C Data   | 3                 | GPIO 2 / SDA1 | 3.3 V   | NOT 5V TOLERAGE |

# GPS
# gps WORKING
yellow - 3.3v - pi physical #17 (3.3)
black - gnd - pi physical #6 (gnd)
white - pps - pi Physical #12 (gpio 18)
blue - rx (module) to tx (pi) pi physical #8 (tx)
green - tx (module) to rx (pi) pi physical #10 (rx)
baud 9600

# RTC
# i2c rtc WORKING!
red - 3.3v - pi physical #1 (3.3)
black - gnd - pi physical #9 (gnd)
brown - scl - pi physical #5  (i2c clock)
green - sda - pi physical #3 (i2c data)