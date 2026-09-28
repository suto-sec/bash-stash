# checker spec for 1821 (see lib/engine.sh)
SCRIPT_NAME=arbol.sh
COMPARE="stdout exit errmsg"
setup() { mkdir -p t/{a/b/c,d,e}; local i; for i in $(seq 7); do touch "t/$(pick . a a/b a/b/c d)/$(word)$i"; done; ln -s a t/link_a; ln -s /etc t/a/etc; touch t/.oculto; }
ARGS=('t' 't/a' 'noexiste')
extra_check() { must_not_use find tree; }
