#!/bin/bash
case $1 in
  sat|sun) echo weekend ;;
  *) echo weekday ;;
esac
