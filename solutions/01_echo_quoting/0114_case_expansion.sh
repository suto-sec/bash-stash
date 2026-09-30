#!/bin/bash
read -r FIRST LAST < person.txt
FIRST=${FIRST,,}; FIRST=${FIRST^}
LAST=${LAST,,}; LAST=${LAST^}
NAME="$FIRST $LAST"
I1=${FIRST:0:1} I2=${LAST:0:1}
LOGIN="${I1}${LAST}"
echo "Name    : $NAME"
echo "Reversed: ${LAST^^}, $FIRST"
echo "Initials: ${I1^^}.${I2^^}."
echo "Login   : ${LOGIN,,}"
echo "Length  : ${#NAME}"

