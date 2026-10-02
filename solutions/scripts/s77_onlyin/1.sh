#!/bin/bash
comm -23 <(ls "$1" | sort) <(ls "$2" | sort)
