#!/bin/bash
bzcat datos/notas.dat.bz2
bzip2 datos/normal/*.dat
bzip2 -k datos/plantilla.dat

