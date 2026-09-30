# checker spec for 0830 (see lib/engine.sh)
SCRIPT_NAME=preserve_special.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  touch a b c d e f_plain "mi archivo"
  chmod "$(pick 755 700 711 644)" a
  chmod "$(pick 4755 4700 4711)" b
  chmod "$(pick 2750 2700 2770)" c
  chmod "$(pick 1777 1755)" d
  chmod "$(pick 6750 6755)" e
  chmod "$(pick 644 640 600)" f_plain
  chmod "$(pick 4640 2600 700)" "mi archivo"
  mkdir carpeta
}
ARGS=(
  'a 700'
  'b 700'
  'c 640'
  'd 777'
  'e 711'
  'f_plain 600'
  '"mi archivo" 640'
  '"$W/a" 700'
  'a 7000'
  'a rwx'
  'a'
  'carpeta 700'
  'noexiste 700'
  ''
)
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
