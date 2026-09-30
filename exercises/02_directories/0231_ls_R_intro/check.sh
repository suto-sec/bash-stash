# checker spec for 0231 (see lib/engine.sh)
setup() { mkdir -p arbol/sub; touch "arbol/$(word).txt" "arbol/sub/$(word).txt"; }
extra_check() { must_use ls; }
