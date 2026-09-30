#!/bin/bash
( umask 077; touch secreto.txt; mkdir privado )
touch normal.txt
umask 007
touch grupo.txt
mkdir grupo_dir
umask
stat -c '%A %n' secreto.txt privado normal.txt grupo.txt grupo_dir

