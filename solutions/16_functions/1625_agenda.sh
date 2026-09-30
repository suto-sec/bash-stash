#!/bin/bash
# agenda.sh COMANDO [ARGS...]
F=agenda.txt

die() {
  local code=$1; shift
  echo "ERROR: $*" >&2
  exit "$code"
}

listar() {
  [ $# -eq 0 ] || die 3 "listar: no admite argumentos"
  if [ ! -s "$F" ]; then echo "agenda vacia"; return; fi
  sort "$F" | sed 's/:/: /'
}

buscar() {
  [ $# -eq 1 ] || die 3 "buscar: uso: buscar NOMBRE"
  local nombre=$1 encontrados
  encontrados=$( [ -f "$F" ] && grep "^$nombre:" "$F" )
  if [ -z "$encontrados" ]; then
    echo "no encontrado"
  else
    echo "$encontrados" | sed 's/:/: /'
  fi
}

borrar() {
  [ $# -eq 1 ] || die 3 "borrar: uso: borrar NOMBRE"
  local nombre=$1 k
  k=$( [ -f "$F" ] && grep -c "^$nombre:" "$F" )
  k=${k:-0}
  [ -f "$F" ] && sed -i "/^$nombre:/d" "$F"
  echo "borrados: $k"
}

add() {
  [ $# -eq 2 ] || die 3 "add: uso: add NOMBRE TELEFONO"
  local nombre=$1 tel=$2
  [[ $tel =~ ^[0-9]+$ ]] || die 4 "add: telefono invalido: '$tel'"
  echo "$nombre:$tel" >> "$F"
  echo "agregado: $nombre"
}

[ $# -ge 1 ] || die 1 "usage: $(basename "$0") COMANDO [ARGS...]"
comando=$1
shift
case $comando in
  listar) listar "$@" ;;
  buscar) buscar "$@" ;;
  borrar) borrar "$@" ;;
  add) add "$@" ;;
  *) die 2 "comando desconocido: '$comando'" ;;
esac
