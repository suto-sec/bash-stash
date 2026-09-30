#!/bin/bash
find store -type f -links +1 | sort
echo ---
find store -samefile store/original.dat | sort

