#!/bin/bash
# Usage: script_test.sh origen destino
if test $# -ne 2
then
  echo "Numero de argumentos incorrecto. Debe ser = 2" ; exit 1 ;
fi
if ! test -e $1
then
  echo "El fichero $1 no existe" ; exit 1 ;
fi
if test -e $2
then
  echo "El fichero $2 existe. ¿Sobreescribir? (s/n)"
  read OPCION
  if test $OPCION = s
  then
    echo "Sobreescribiendo"
    cp $1 $2; exit $? ;
  else
    echo "Saliendo sin sobreescribir" ; exit 1 ;
  fi
else
  cp $1 $2; exit $? ;
fi
