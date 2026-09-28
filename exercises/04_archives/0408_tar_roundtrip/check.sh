# checker spec for 0408 (see lib/engine.sh)
setup() { mkdir -p proyecto/{src,doc}; local i; for i in 1 2 3; do randtext 4 > "proyecto/src/$(word)$i.c"; done; randtext 2 > proyecto/doc/README; }
extra_check() {
  must_use mktemp
  [[ -f $W/proyecto.tgz ]] && tar tzf "$W/proyecto.tgz" >/dev/null 2>&1 || fail "proyecto.tgz missing or not a valid .tgz"
}
