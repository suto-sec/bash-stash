# checker spec for 0822 (see lib/engine.sh)
SCRIPT_NAME=perm_diff.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "orig/sub dir" orig/x copia
  local i f m
  for i in $(seq 1 8); do
    f="$(pick . "sub dir" x)/$(pick "$(word)$i.txt" "$(word) $i")"
    touch "orig/$f"; m=$(pick 644 600 755 640 700); chmod "$m" "orig/$f"
  done
  cp -r orig/. copia/
  (cd orig && find . -type f) | while IFS= read -r f; do
    case $(rand 5) in
      0) chmod "$(pick 666 604 750)" "copia/$f" ;;
      1) rm "copia/$f" ;;
    esac
  done
  mkdir -p "copia/sub dir"; touch "copia/sub dir/$(word)_new"
  cp -rp orig igual; touch fich
}
ARGS=('orig copia' '"$W/copia" orig' 'orig igual' 'orig' '' 'orig fich' 'noexiste orig' 'a b c')
extra_check() {
  [[ $REF_CODE == 3 ]] && { eval "set -- $CASE"; if [ -d "$W/$1" ]; then mentions "$2"; else mentions "$1"; fi; }
  true
}
