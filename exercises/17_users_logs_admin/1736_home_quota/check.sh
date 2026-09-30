# checker spec for 1736 (see lib/engine.sh)
SCRIPT_NAME=cuota.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i u h
  mkdir -p "casas/sub dir"
  for i in $(seq "$(randr 5 9)"); do
    u=$(word)$i; h="$W/casas/$(pick . "sub dir")/$u"
    case $(rand 6) in
      0) ;;
      1) echo x > "$h" ;;
      2) mkdir -p "$h"; bigfile "$h/f" 8192; chmod "$(pick 000 300 600)" "$h" ;;
      *) mkdir -p "$h/docs"; bigfile "$h/a" $(( $(randr 1 40) * 4096 )); bigfile "$h/docs/b" $(( $(randr 0 40) * 4096 )) ;;
    esac
    echo "$u:x:$(pick 1000 1001 2500 999 60000 1200):100::$h:/bin/bash"
  done > "mi passwd"
}
ARGS=('50 "mi passwd"' '1 "$W/mi passwd"' '100 "mi passwd"' '100000 "mi passwd"' '0 "mi passwd"' 'x10 "mi passwd"' '50 noexiste' '' '1 2 3')
