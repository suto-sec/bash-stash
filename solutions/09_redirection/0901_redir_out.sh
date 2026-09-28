#!/bin/bash
ls datos > listado.txt
echo "--- total: $(ls datos | wc -l)" >> listado.txt
echo fin > ultima.txt

