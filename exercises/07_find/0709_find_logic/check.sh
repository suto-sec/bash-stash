# checker spec for 0709 (see lib/engine.sh)
setup() { mkdir -p docs/{alfa,beta~,c}; local i; for i in $(seq 10); do touch "docs/$(pick . alfa c)/$(pick a b c A)$(word)$i$(pick '' '~' '.txt')"; done; }
