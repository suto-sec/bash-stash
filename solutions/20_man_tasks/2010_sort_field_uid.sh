#!/bin/bash
sort -t: -k3 -n cuentas.txt | cut -d: -f1

