# checker spec for 0701 (see lib/engine.sh)
setup() { mkdir -p lib/{a,b/c}; local i; for i in 1 2 3 4; do touch "lib/$(pick a b b/c)/ls$(word)$i.so" "lib/$(pick a b)/$(word)ls$i.so" "lib/ls$(word)$i.so.1"; done; touch lsfake.so; }
