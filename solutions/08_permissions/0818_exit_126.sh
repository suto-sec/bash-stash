#!/bin/bash
./hola.sh 2>/dev/null
echo "exit: $?"
bash hola.sh
./nada.sh 2>/dev/null
echo "exit: $?"
chmod u+x hola.sh
./hola.sh
cat cerrado/dato 2>/dev/null
echo "exit: $?"
chmod u+x cerrado
cat cerrado/dato

