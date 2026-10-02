# checker spec for 2016 (see lib/engine.sh)
SEEDS=3
SCRIPT_NAME=nuevo.sh
COMPARE="stdout errmsg exit"
ARGS=( 'a b' 'b a' 'a nofile' 'nofile a' '' 'a' 'a b c' )
setup() {
  mkf a "a"; mkf b "b"
  if (( $(rand 2) == 0 )); then touch -d '2024-01-01' a; touch -d '2024-06-01' b; else touch -d '2024-06-01' a; touch -d '2024-01-01' b; fi
}
extra_check() { must_use -nt; }
