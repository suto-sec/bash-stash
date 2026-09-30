# checker spec for 0557 (see lib/engine.sh)
SCRIPT_NAME=bytesdiff.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('a.bin b.bin' 'a.bin c.bin' 'a.bin corto.bin' 'a.bin' 'a.bin b.bin extra' 'nofile.bin b.bin' 'a.bin nofile.bin')
setup() {
  local content s pos i n len
  content=""
  for i in $(seq "$(randr 10 18)"); do content+="$(word)"; done
  s=$content
  len=${#s}
  n=$(randr 1 3)
  for i in $(seq "$n"); do
    pos=$(rand "$len")
    s="${s:0:pos}#${s:pos+1}"
  done
  printf '%s' "$content" > a.bin
  printf '%s' "$s" > b.bin
  printf '%s' "$content" > c.bin
  printf '%sX' "$content" > corto.bin
}
extra_check() {
  [[ $REF_CODE == [123] && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *bytesdiff.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == nofile* ]] && mentions nofile.bin
       [[ $CASE == *nofile.bin ]] && mentions nofile.bin ;;
    3) mentions corto.bin ;;
  esac
}
