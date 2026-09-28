# checker spec for 1809 (see lib/engine.sh)
SCRIPT_NAME=usuarios.sh
COMPARE="stdout exit errmsg"
setup() {
  local i u
  cp /etc/group grp
  for i in $(seq 6); do u="$(word)$i"; echo "$u:x:$(pick 999 1000 1500 60000 1200):100:$(word):/home/$(pick $u luke alumno $u):/bin/$(pick bash sh)"; [[ $(rand 2) == 1 ]] && sed -i "/^devs:/ s/\$/,$u/" grp; done > pw
}
ARGS=('' 'pw grp' 'noexiste' 'pw noexiste')
