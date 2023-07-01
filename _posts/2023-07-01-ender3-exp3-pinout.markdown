---
layout: single
title: "Ender 3 EXP3 pinout for hardware hacking"
categories: "hardware"
---

The Ender 3 display is based on the open Reprap screen design, but includes a header called `EXP3`
that allows for communication with a single cable. This header communicates with the display over 
SPI, but the documentation I could find online was sparse and conflicting. I verified the pinout 
and created this graphic to document this header's pinout.

This display uses the ST7920 controller. The arduino library u8g2 has support for it.

![Graphic explaining the pinout. Textual pinout below](/assets/ender3/ender3-exp3-pinout.png)

## Text Documentation for Accessibility

The notch on the display board is on the top. Pins are left to right.

| Ground     | Chip Select    | Knob Rotation        | Knob Rotation 2          | Beeper          |
| 5V         | Data           | Clock                | Unknown                  | Button          |
{: style="display: table; margin-left: auto; margin-right: auto; width: 100%;" }

### SPI Pins

* Chip Select
* Data
* Clock

### Digital Buttons

* Knob Rotation 1
* Knob Rotation 2
* Button
