# checker spec for 1840 (see lib/engine.sh)
SCRIPT_NAME=verify_backup.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p src/a src/b "src/con espacio" dest/a dest/b
  echo contenido1 > src/a/f1.txt
  cp src/a/f1.txt dest/a/f1.txt
  echo contenido2 > src/b/f2.txt
  echo distinto > dest/b/f2.txt
  echo contenido3 > "src/con espacio/f3.txt"
  local i w
  for i in $(seq 3); do
    w=$(word)$i
    echo "dato $w" > "src/a/$w.txt"
    cp "src/a/$w.txt" "dest/a/$w.txt"
  done
  touch src_no_dir dest_no_dir
}
ARGS=('' 'src' 'src dest extra' 'noexiste dest' 'src_no_dir dest' 'src noexiste' 'src dest_no_dir' 'src dest')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *verify_backup.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
    5) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
