# checker spec for 0402 (see lib/engine.sh)
setup() { mkdir -p src/{a,b}; local i; for i in $(seq "$(randr 2 6)"); do randtext 2 > "src/$(pick a b)/$(word)$i"; done; tar --sort=name -czf backup.tgz src; rm -r src; }
