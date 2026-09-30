# checker spec for 0922 (see lib/engine.sh)
SCRIPT_NAME=bundle.sh
SEEDS=3
COMPARE="stdout exit files errmsg"
setup() {
  mkdir parts
  local f i
  for f in parts/a.txt "parts/my notes.txt" parts/b.log locked.txt; do
    for i in $(seq "$(randr 1 5)"); do words "$(randr 1 4)"; done > "$f"
  done
  chmod 000 locked.txt
  echo "old content $(word)" > out.txt
  true
}
ARGS=('out.txt parts/a.txt "parts/my notes.txt"' '"all parts.txt" parts/b.log parts/a.txt parts/b.log' 'out.txt parts/a.txt nofile locked.txt'
      'out.txt parts' 'out.txt parts/a.txt ./out.txt' '"$W/out.txt" out.txt' 'out.txt' '' 'nodir/x.txt parts/a.txt')
extra_check() {
  [[ $CASE == *nofile* ]] && mentions nofile
  [[ $CASE == *nofile* ]] && mentions locked.txt
  true
}
