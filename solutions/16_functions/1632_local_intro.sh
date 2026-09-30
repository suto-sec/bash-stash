#!/bin/bash
X=fuera
f() { local X=dentro; echo "$X"; }
echo "$X"
f
echo "$X"
