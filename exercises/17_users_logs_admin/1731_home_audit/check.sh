# checker spec for 1731 (see lib/engine.sh)
SCRIPT_NAME=homes.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i u h
  mkdir -p homes "other homes"
  for i in $(seq "$(randr 5 10)"); do
    u=$(word)$i; h="$W/$(pick homes "other homes")/$u"
    case $(rand 5) in
      0) ;;
      1) echo data > "$h" ;;
      *) mkdir "$h"; chmod "$(pick 700 750 755 701 770 711 777 704)" "$h" ;;
    esac
    echo "$u:x:$(pick 500 1000 1234 2000 60001 1500):100:$(word):$h:/bin/bash"
  done > "my passwd"
  echo "ok:x:1999:100::$W:/bin/sh" > okpw; chmod 750 "$W"
}
ARGS=('"my passwd"' '"$W/my passwd"' 'okpw' '' 'noexiste' 'a b')
