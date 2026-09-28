#!/bin/bash
ln -s ../borrador Datos/Stocks/enlacesimbolico
ln -s "$PWD/Datos" acceso
readlink Datos/Stocks/enlacesimbolico
readlink acceso
cat Datos/Stocks/enlacesimbolico

