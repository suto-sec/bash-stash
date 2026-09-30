# checker spec for 0825 (see lib/engine.sh)
SCRIPT_NAME=share.sh
SEEDS=2
RUN_AS_ROOT=1
COMPARE="stdout exit errmsg files owner"
setup() {
  mkdir -p "proyecto/src/mi modulo" proyecto/doc vacio
  local i f
  for i in $(seq 1 7); do
    f="proyecto/$(pick . src "src/mi modulo" doc)/$(pick "$(word)$i.c" "$(word) $i.sh" "$(word)$i")"
    touch "$f"; chmod "$(pick 644 600 755 700 640 744 604)" "$f"
  done
  chmod "$(pick 755 700)" proyecto/doc
  touch fich
}
ARGS=('devs proyecto' 'secops "$W/proyecto/src"' 'scanner vacio' 'rod proyecto' 'nogroup_xyz proyecto' 'devs fich' 'devs' '')
extra_check() {
  [[ $CASE == nogroup_xyz* ]] && mentions nogroup_xyz
  true
}
