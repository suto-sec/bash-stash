#!/bin/bash
./ruidoso.sh 2> /dev/null
./ruidoso.sh > /dev/null
./ruidoso.sh &> /dev/null
echo "exit code: $?"

