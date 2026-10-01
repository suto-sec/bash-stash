#!/bin/bash
case $1 in
  upper) echo "${2^^}" ;;
  lower) echo "${2,,}" ;;
  len) echo "${#2}" ;;
esac
