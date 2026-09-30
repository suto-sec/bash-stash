# checker spec for 1620 (see lib/engine.sh)
SCRIPT_NAME=buscar.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkfl "notas a.txt" "linux is $(word)" "kernel process $(word)" "$(word) linux thread"
  mkfl otras.txt "$(word) $(word)" "signal socket buffer"
  echo secreto > oculto.txt
  chmod 000 oculto.txt
}
ARGS=('' 'linux' 'linux "notas a.txt"' 'linux "notas a.txt" otras.txt' 'process otras.txt oculto.txt'
      'thread nofile.txt "notas a.txt"' '"" "notas a.txt"' 'kernel "notas a.txt" otras.txt oculto.txt nofile.txt')
extra_check() {
  local a f; eval "a=( $CASE )"
  for ((i = 1; i < ${#a[@]}; i++)); do
    f=${a[i]}
    if [[ ! -f "$W/$f" || ! -r "$W/$f" ]]; then mentions "$f"; fi
  done
  [[ $REF_CODE == 1 && $ERR != *buscar.sh* && $ERR != *sage* ]] && fail "the usage message should show how to call the script"
  true
}
