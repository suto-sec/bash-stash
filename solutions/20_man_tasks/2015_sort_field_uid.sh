#!/bin/bash
sort -t: -k3 -nr cuentas.txt | cut -d: -f1

