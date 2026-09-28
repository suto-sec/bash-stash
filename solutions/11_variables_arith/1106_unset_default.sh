#!/bin/bash
COLOR=azul
echo "color: $COLOR"
unset COLOR
echo "color: ${COLOR:-negro}"
echo "color: $COLOR"
echo "color: ${COLOR:=rojo}"
echo "color: $COLOR"
echo ${#HOME}

