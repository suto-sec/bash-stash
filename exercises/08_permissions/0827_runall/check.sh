# checker spec for 0827 (see lib/engine.sh)
SCRIPT_NAME=runall.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p tareas "tareas/$(word)_dir" solo
  local i f c
  for i in $(seq 1 6); do
    f="tareas/$(pick "$(word)$i.sh" "$(word) $i" "t$i")"
    c=$(pick 0 0 1 3)
    printf '#!/bin/bash\necho "%s: $# args: $*"\nexit %s\n' "$(basename "$f")" "$c" > "$f"
    chmod "$(pick 755 700 644 600 744 711 755)" "$f"
  done
  printf '#!/bin/bash\necho "unreadable"\n' > "tareas/zz locked"; chmod 311 "tareas/zz locked"
  printf 'echo "no shebang: $1"\n' > tareas/noshebang; chmod 755 tareas/noshebang
  ln -s noshebang "tareas/$(word)_link"
  chmod 755 "tareas/$(word)_dir" 2>/dev/null
  printf '#!/bin/bash\necho solo ok\n' > solo/uno; chmod 755 solo/uno
  touch fich
}
ARGS=('tareas' 'tareas "hola mundo" 2' '"$W/tareas" x' 'solo' 'fich' 'noexiste a' '')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  true
}
