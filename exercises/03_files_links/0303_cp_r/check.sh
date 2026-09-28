# checker spec for 0303 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p backup proyecto/{src,doc}; local f; for f in proyecto/README proyecto/src/$(word).c proyecto/doc/$(word).md; do randtext 3 > "$f"; done; }
