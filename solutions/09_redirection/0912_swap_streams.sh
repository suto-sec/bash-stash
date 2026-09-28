#!/bin/bash
./ruidoso.sh 3>&1 1>&2 2>&3 | tr a-z A-Z
