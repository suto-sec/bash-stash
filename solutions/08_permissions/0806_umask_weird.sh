#!/bin/bash
umask 362
mkdir nuevodir
touch nuevofichero_fuera
chmod u+x nuevodir
chmod u+w nuevodir
touch nuevodir/nuevofichero
chmod u+w nuevodir/nuevofichero
echo hola > nuevodir/nuevofichero

