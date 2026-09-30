# checker spec for 0834 (see lib/engine.sh)
SCRIPT_NAME=check_access.sh
SEEDS=3
RUN_AS_ROOT=1
COMPARE="stdout exit errmsg"
setup() {
  local f
  for f in a b c d "mi archivo"; do
    touch "$f"
    chmod "$(pick 644 600 640 750 705 044 070 007 755 460 406 066)" "$f"
    chgrp "$(pick alumno adm secops audio video cdrom)" "$f"
  done
}
ARGS=('jgarcia a' 'alumno b' 'luke c' 'sally d' 'rod a' 'jgarcia "mi archivo"' 'nadie a' 'root a' 'jgarcia noexiste' 'jgarcia' '')
extra_check() {
  [[ $CASE == 'nadie a' ]] && mentions nadie
  [[ $CASE == *noexiste* ]] && mentions noexiste
  true
}
