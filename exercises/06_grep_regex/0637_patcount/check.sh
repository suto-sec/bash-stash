# checker spec for 0637 (see lib/engine.sh)
SCRIPT_NAME=patcount.sh
SEEDS=3
COMPARE="stdout exit errmsg"
PATS=(1.2.3.4 '[error]' -v 'a*b' 'disk full' Timeout '^start' 'end$' 'x\y' 'zzz-none' '--force')
setup() {
  local i
  { echo "# patterns to look for"; for i in $(seq 7); do pick "${PATS[@]}" '' "$(word)"; done; } > patterns.txt
  { echo "# my list"; for i in $(seq 4); do pick "${PATS[@]}"; done; } > "my patterns.txt"
  printf '%s\n' "# none of these" zzz-none '' 'qqq.www' > none.txt
  for i in $(seq 25); do
    echo "$(word) $(pick 1.2.3.4 1x2x3x4 '[error]' error '[ERROR] x' --verbose -v 'aab' 'a*b' 'A*B' 'Disk Full' 'disk  full' TIMEOUT '^start' start 'the end$' 'x\y' --force '') $(word)"
  done > data.log
  cp data.log "data file.log"
}
ARGS=('patterns.txt data.log' '"my patterns.txt" "data file.log"' 'none.txt data.log' '' 'patterns.txt' 'a b c' 'nofile data.log' 'patterns.txt nofile')
extra_check() { [[ $REF_CODE == [23] ]] && mentions nofile; true; }
