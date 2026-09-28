#!/bin/bash
read -p "Name: " NAME
read -p "Age: " AGE
if [[ $AGE =~ ^[0-9]+$ ]]; then
  echo "Hello $NAME, next year you will be $((AGE + 1))"
else
  echo "Hello $NAME, that is not an age"
fi

