# checker spec for 0405 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 2 > "$(word).txt"; for f in *.txt; do tar -cf coleccion.tar "$f"; rm "$f"; done; randtext 2 > nuevo1.txt; randtext 3 > nuevo2.txt; }
extra_check() { ans_code | grep -qE 'tar +-?[a-zA-Z]*r' || fail "append with tar -r (don't recreate the archive)"; }
