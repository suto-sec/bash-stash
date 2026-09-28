# checker spec for 0705 (see lib/engine.sh)
setup() { mkdir -p arbol/{a/b/c/d,e/f,g}; local d; for d in arbol arbol/a arbol/a/b arbol/a/b/c arbol/e/f; do touch "$d/$(word).txt"; done; }
