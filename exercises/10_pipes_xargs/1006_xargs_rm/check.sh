# checker spec for 1006 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p a/b c; local i; for i in $(seq 8); do touch "$(pick . a a/b c)/$(word)$i$(pick '~' '' '.bak')"; done; }
extra_check() { must_use xargs; }
