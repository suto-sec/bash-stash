# checker spec for 1545 (see lib/engine.sh)
SCRIPT_NAME=grep_dir.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "logs/sub uno" "logs/sub dos/deep"
  mkfl "logs/a $(word)1.txt" "linux kernel" "process signal" "linux linux"
  mkfl "logs/sub uno/b $(word)2.txt" "socket buffer" "linux"
  mkfl "logs/sub dos/c $(word)3.txt" "nothing here"
  mkfl "logs/sub dos/deep/d $(word)4.txt" "linux thread linux"
  touch "logs/vacio.txt"
  touch nota.txt
}
ARGS=('logs linux' 'logs socket' 'logs nomatch' '' 'logs' 'nada linux' 'nota.txt linux' 'logs ""')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  must_use read
}
