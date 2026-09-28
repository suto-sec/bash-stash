#!/bin/bash
doit() {
  cp $1 $2
  return
}
function check() {
  if [ -s $2 ]
  then
    echo "Target file exists! Exiting!"
    exit 1
  fi
}
check $1 $2
doit $1 $2
exit 0
