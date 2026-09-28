#!/bin/bash
find compartido -type f -perm -o+w | sort
find compartido -type f -perm -o+w -exec chmod o-w {} +
find compartido -type f -name '*.key' -exec chmod go= {} +

