# checker spec for 1719 (see lib/engine.sh)
SCRIPT_NAME=shells.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i f sh=(/bin/bash /bin/bash /bin/sh /usr/sbin/nologin /bin/false /usr/bin/zsh /bin/dash /usr/bin/bash)
  for f in pw "mi pw"; do
    for i in $(seq "$(randr 5 14)"); do
      echo "$(word)$i:x:$(randr 0 3000):100:$(words 2):/home/u$i:$(pick "${sh[@]}")"
    done > "$f"
  done
  mkdir adir
}
ARGS=('' 'pw' '"mi pw"' '"$W/pw"' 'noexiste' 'adir' 'pw pw')
