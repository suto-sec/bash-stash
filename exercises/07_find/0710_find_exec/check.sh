# checker spec for 0710 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p scripts/{a,b/c}; local i; for i in $(seq 8); do touch "scripts/$(pick . a b/c)/$(word)$i$(pick .sh .txt .sh.bak)"; done; mkdir -p scripts/dir.sh; }
extra_check() { must_use -exec; }
