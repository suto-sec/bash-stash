#!/bin/bash
chmod 640 a
stat -c '%a %n' a b c
chmod 600 b
stat -c '%a %n' a b c

