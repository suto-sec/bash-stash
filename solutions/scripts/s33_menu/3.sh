#!/bin/bash
if (( $# == 0 )); then echo "Error: a command is needed" >&2; echo "Usage: $0 upper|lower|len text" >&2; exit 1; fi
case $1 in
  upper) echo "${2^^}" ;;
  lower) echo "${2,,}" ;;
  len) echo "${#2}" ;;
  *) echo "Error: unknown command '$1'" >&2; exit 2 ;;
esac
