#!/bin/bash
find /home -maxdepth 1 -user luke | sort
echo ---
find /var/log -maxdepth 1 -group adm | sort
echo ---
find /home -maxdepth 1 ! -user root | sort

