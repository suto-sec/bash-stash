# checker spec for 0415 (see lib/engine.sh)
SCRIPT_NAME=pack_ext.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "src/sub 1/deep" src/otros
  local i n=0 f
  for d in src "src/sub 1" "src/sub 1/deep" src/otros; do
    for i in 1 2; do
      n=$((n + 1))
      f="$d/$(word)$n.$(pick log txt log csv)"
      randtext "$(randr 1 4)" > "$f"
    done
  done
  echo x > src/catalog.txt
  echo y > src/logfile
  mkdir -p other
  randtext 2 > other/ignored.log
}
ARGS=(
  'src log out.tar.xz'
  '"src/sub 1" log out2.tar.xz'
  'src csv out3.tar.xz'
  'src'
  'src log'
  'src log a b'
  'noexiste log out.tar.xz'
  'src/catalog.txt log out.tar.xz'
  'src pdf out.tar.xz'
)
capture() {
  local f
  for f in *.tar.xz; do
    [ -e "$f" ] || continue
    echo "== $f =="
    tar -tJf "$f" 2>/dev/null | sort
  done
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *pack_ext.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
