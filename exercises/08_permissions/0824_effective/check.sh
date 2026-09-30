# checker spec for 0824 (see lib/engine.sh)
SCRIPT_NAME=effective.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f
  mkdir "d i r"
  for f in a b "c d" e "d i r"; do
    [ -e "$f" ] || touch "$f"
    chmod "$(pick 640 604 644 600 750 705 044 070 007 755 460 406 066)" "$f"
    chgrp "$(pick alumno adm secops audio video cdrom)" "$f"
  done
}
ARGS=('jgarcia a b "c d" e "d i r" /etc/shadow' 'alumno a b "c d" e "d i r"' 'luke a b "c d" e /etc/passwd' 'sally a b "c d" e' 'rod a "c d" /etc/shadow' 'jgarcia a noexiste b' 'nadie a' 'root a' 'jgarcia' '')
extra_check() {
  [[ $CASE == 'nadie a' ]] && mentions nadie
  [[ $CASE == *noexiste* ]] && mentions noexiste
  true
}
