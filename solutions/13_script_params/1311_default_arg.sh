#!/bin/bash
DIR=${1:-.}
N=${2:-3}
ls "$DIR" | head -n "$N"

