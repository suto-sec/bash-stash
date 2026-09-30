# checker spec for 0426 (see lib/engine.sh)
SEEDS=1
setup() { randtext 3 > datos.txt; }
extra_check() {
  [[ -f $W/archivo.tar ]] || { fail "archivo.tar was not created"; return; }
  tar tf "$W/archivo.tar" 2>/dev/null | grep -qx datos.txt || fail "archivo.tar doesn't contain datos.txt"
}
