# checker spec for 0828 (see lib/engine.sh)
SCRIPT_NAME=umask_audit.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "datos/sub dir/x" datos/pub limpio/a
  local i f
  for i in $(seq 1 8); do
    f="datos/$(pick . "sub dir" "sub dir/x" pub)/$(pick "$(word)$i" "$(word) $i.txt")"
    touch "$f"; chmod "$(pick 644 600 755 666 664 640 777 700 604)" "$f"
  done
  chmod "$(pick 775 777 750 755)" "datos/sub dir"; chmod "$(pick 755 700)" datos/pub
  ln -s ../pub "datos/sub dir/link"
  touch limpio/a/f; chmod 600 limpio/a/f; chmod 700 limpio/a
  touch fich
}
ARGS=('022 datos' '-f 022 datos' '-f 0077 "$W/datos"' '027 "datos/sub dir"' '-f 002 datos' '077 limpio' '022' '-x 022 datos' '022 fich' '22 datos' '099 datos' '722 datos' '' '-f 022 datos extra')
extra_check() {
  [[ $REF_CODE == 3 ]] && { eval "set -- $CASE"; [ "$1" = -f ] && shift; mentions "$1"; }
  true
}
