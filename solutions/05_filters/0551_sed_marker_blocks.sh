#!/bin/bash
sed -n '/^BEGIN$/,/^END$/{/^BEGIN$/d;s/^END$/---/;p}' bitacora.txt

