### U-BLOX LEA-M8T-0-10 HUAWEI GPS Module
**Pins are 2mm pitch**
**3.3 Volts**
| Cable  | Module Pin | Module Pin Meaning       | Raspberry Pi 4 Pin         | Voltage                 | Notes                                                     |
|:-------|:-----------|:-------------------------|:---------------------------|:-----------------|:----------------------------------------------------------|
| Red    | 2 - VCC        | Voltage In           | 1 - 3.3 Volts Out (Split)  | 3.3 V            | NOT 5 V TOLERANT                                          |
| Black  | 8 - GND        | Ground               | 25 - Ground                | 3.3 V?           | UNKNOWN 3 V AND 5 V TOLERANCES                            |
| Yellow | 4 - RST        | Hardware Reset       | NC? - Not Connected/GPIO?  | 3.3 V            | NOT 5 V TOLERANT                                          |
| White  | 6 - TP1        | Time Pulse 1/PPS     | 12 - GPIO 18               | 3.3 V            | NOT 5 V TOLERANT                                          |
| Purple | 7 - TP2        | Time Pulse 2/PPS     | NC? - Not Connected/GPIO?  | 3.3 V            | NOT 5 V TOLERANT                                          |
| Green  | 5 - RXD        | UART Receive         | 8 - UART Transmit          | 3.3 V            | NOT 5 V TOLERANT                                          |
| Grey   | 3 - TXD        | UART Transmi  t      | 10 - UART Receive          | 3.3  V           | NOT 5 V TOLERANT                                          |
| Orange | 1 - VCC_ANT    | Antenna Power Supply | NC? Regulated Power Supply | 5.0 V Max 100 mA   | MUST USE REGULATED POWER SUPPLY AND UNKNOWN 3 V TOLERANCE |

### Adafruit DS3231 Precision RTC Breakout
**Pins are 2.54mm pitch**
**3.3 Volts**
| Cable | Module Pin    | Module Pin Meaning | Raspberry Pi 4 Pin | Voltage |
|:------|:--------------|:-------------------|:-------------------|:--------|
| Red   | 1 - VIN       | Voltage In         | 1 - 3v3            | 3.3 V   |
| Black | 2 - GND       | Ground             | 9 - Ground         | 3.3 V   |
| Brown | 3 - SCL       | I2C Clock          | 5 - GPIO 4 / SCL1  | 3.3 V   |
| Green | 4 - SDA       | I2C Data           | 3 - GPIO 2 / SDA1  | 3.3 V   |