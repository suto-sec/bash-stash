#!/bin/bash
useradd -m -s /bin/bash -c "Pepe Perez" -G devs pepe
echo 'pepe:lab' | chpasswd
getent passwd pepe
id -Gn pepe

