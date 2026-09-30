#!/bin/bash
umask 077
cp script.sh copia1.sh
cp -p script.sh copia2.sh
cat script.sh > copia3.sh
mkdir -m 750 d
mkdir d2
stat -c '%a %n' script.sh copia1.sh copia2.sh copia3.sh d d2

