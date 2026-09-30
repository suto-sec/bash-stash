# checker spec for 1828 (see lib/engine.sh)
SCRIPT_NAME=newer_than.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  touch -d '2026-06-10 09:00' ref.txt
  touch -d '2026-06-05 09:00' d/old_guaranteed
  touch -d '2026-06-20 09:00' d/new_guaranteed
  local i f
  for i in $(seq 5); do
    f="d/$(pick . sub 'con espacio')/$(word)$i"
    touch -d "2026-06-$(printf '%02d' "$(randr 1 28)") 09:00" "$f"
  done
  touch archivo_no_dir
}
ARGS=('' 'd ref.txt' 'd ref.txt extra' 'noexiste ref.txt' 'archivo_no_dir ref.txt' 'd noexiste.txt' 'd/sub ref.txt')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
