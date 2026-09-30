# checker spec for 0218 (see lib/engine.sh)
setup() {
  mkdir -p proyecto/{src/net,src/util,include,build/obj,docs}
  local i f
  for i in 1 2 3 4 5 6; do
    f=$(word)$i
    touch "proyecto/$(pick src src/net src/util)/$f.c" "proyecto/build/obj/$f.o" "proyecto/include/$f.h"
  done
  touch "proyecto/src/util/$(word).o" proyecto/build/app proyecto/docs/README.md "proyecto/docs/.$(word)" proyecto/docs/.notes
  local ddir; ddir=$(word); mkdir -p "proyecto/docs/$ddir"; touch "proyecto/docs/$ddir/index.md"
}
extra_check() { must_use tree; }
