#!/bin/bash
if (( $# == 0 )); then echo "Error: a command is needed" >&2; echo "Usage: $0 upper|lower|len text" >&2; exit 1; fi
case $1 in
  upper|lower|len) ;;
  *) echo "Error: unknown command '$1'" >&2; exit 2 ;;
esac
if (( $# != 2 )); then echo "Error: exactly one text is needed" >&2; echo "Usage: $0 upper|lower|len text" >&2; exit 3; fi
case $1 in
  upper) echo "${2^^}" ;;
  lower) echo "${2,,}" ;;
  len) echo "${#2}" ;;
esac
