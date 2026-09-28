#!/bin/bash
passwd -l rmartin > /dev/null
passwd -S rmartin | cut -d' ' -f2
passwd -u rmartin > /dev/null
passwd -S rmartin | cut -d' ' -f2
passwd -e rmartin > /dev/null
passwd -S rmartin | cut -d' ' -f3

