# checker spec for 1826 (see lib/engine.sh)
SCRIPT_NAME=topwords.sh
COMPARE="stdout exit errmsg"
setup() {
  local i
  {
    for i in 1 2 3; do echo "Bash Bash bash SCRIPT script Process process thread $(word) $(word)"; done
    echo "Kernel kernel KERNEL buffer buffer cache Cache signal"
  } > texto.txt
  cp texto.txt "texto con espacio.txt"
  : > vacio.txt
  touch noleible.txt
  chmod 000 noleible.txt
}
ARGS=('' 'texto.txt' 'texto.txt 0' 'texto.txt abc' 'texto.txt 2' 'texto.txt' 'texto.txt 100' 'noleible.txt' 'noexiste.txt' 'vacio.txt' '"texto con espacio.txt" 3' 'a b c')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
