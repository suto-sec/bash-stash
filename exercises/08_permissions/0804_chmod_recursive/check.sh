# checker spec for 0804 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p web/{css,js,img/icons}; local i f; for i in $(seq 8); do f="web/$(pick . css js img img/icons)/$(word)$i.$(pick html css js sh)"; touch "$f"; chmod "$(pick 600 666 700 755 640 777)" "$f"; done; chmod 700 web/css; chmod 777 web/js; }
extra_check() { max_lines 1; }
