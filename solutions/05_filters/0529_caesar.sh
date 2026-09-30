#!/bin/bash
a=abcdefghijklmnopqrstuvwxyz
r=$(echo "$a$a" | cut -c$(( $1 + 1 ))-$(( $1 + 26 )))
tr 'a-zA-Z' "$r${r^^}"

