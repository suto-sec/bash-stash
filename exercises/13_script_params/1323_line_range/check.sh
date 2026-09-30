# checker spec for 1323 (see lib/engine.sh)
SCRIPT_NAME=lines.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  { randtext "$(randr 2 5)"; echo '   indented \t line'; randtext "$(randr 3 8)"; } > "my notes.txt"
  randtext "$(randr 4 12)" > log.txt
  : > empty.txt
  echo secret > locked.txt; chmod 000 locked.txt
  mkdir sub
}
ARGS=('"my notes.txt" 2 4' '"my notes.txt" 3' 'log.txt 1 100' 'log.txt 50' 'empty.txt 1' '"my notes.txt" 5 2' '"my notes.txt" 0 3' '"my notes.txt" 2 x' '"my notes.txt" 02' 'nofile 1 2' 'locked.txt 1' 'sub 1' '"my notes.txt"' 'a 1 2 3' '"$W/log.txt" 2 2' 'log.txt 3 3')
extra_check() {
  local tok
  if [[ $REF_CODE == [23] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
