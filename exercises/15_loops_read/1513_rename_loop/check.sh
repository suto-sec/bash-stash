# checker spec for 1513 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir fotos; local i; for i in $(seq 6); do touch "fotos/$(word)$(pick ' ' '_' '')$i.$(pick jpeg jpg png jpeg)"; done; }
