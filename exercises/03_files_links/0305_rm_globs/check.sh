# checker spec for 0305 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  local y q; for y in 16 17 18 19; do for q in 1 2 3 4; do touch "Trimestre.$y.$q.txt"; done; done
  touch Trimestre.17.todos.txt Trimestre.17.antiguos.txt Trimestre.18.1.bak Trimestre.18.12.txt Trimestre.170.txt
  touch "$(pick a b c).log" "$(pick x y z).log" "ab.log" "abc.log" ".log" "$(randr 1 9).log"
}
extra_check() { (( $(ans_code | wc -l) <= 3 )) || fail "use at most 3 rm commands (wildcards!)"; }
