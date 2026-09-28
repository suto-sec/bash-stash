# checker spec for 0609 (see lib/engine.sh)
setup() { mkdir -p src/lib src/test; local f i; for f in src/$(word)1.c src/$(word)2.c src/lib/$(word).h src/test/$(word).c src/README; do for i in $(seq 4); do echo "$(pick 'TODO' 'todo' 'DONE' '') $(words 3)"; done > "$f"; done; }
