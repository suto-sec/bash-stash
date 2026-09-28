#!/bin/bash
sed '/^#/d; /^$/d' config.conf
echo ---
sed -n '2,4p' config.conf
echo ---
sed -n '/port/p' config.conf

