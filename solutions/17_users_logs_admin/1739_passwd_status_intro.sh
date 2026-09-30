#!/bin/bash
passwd -S "$(whoami)" | cut -d' ' -f1

