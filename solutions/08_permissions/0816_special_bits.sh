#!/bin/bash
chmod 1777 tmpcomun
chmod 4755 herramienta
chmod 2770 compartido
chmod 4644 raro
stat -c '%A %a %n' tmpcomun herramienta compartido raro
echo ---
find . -perm /6000 | sort

