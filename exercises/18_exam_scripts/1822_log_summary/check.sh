# checker spec for 1822 (see lib/engine.sh)
SCRIPT_NAME=resumen.sh
COMPARE="stdout stderr exit"
setup() { mkdir -p l/{a,b}; local i f j; for i in $(seq 6); do f="l/$(pick . a b)/$(word)$i.$(pick log log txt)"; for j in $(seq "$(randr 0 8)"); do echo "$(pick INFO ERROR Error WARN warning debug) $(words 2)"; done > "$f"; done; echo x > l/secret.log; [[ $(rand 2) == 1 ]] && chmod 000 l/secret.log; true; }
ARGS=('l' 'l/a' 'noexiste')
filter() { cat; }
extra_check() { [[ $REF_CODE == 1 ]] && [[ -z $ERR ]] && fail "expected an error message on stderr"; true; }
