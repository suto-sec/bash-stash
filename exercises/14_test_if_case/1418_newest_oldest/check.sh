# checker spec for 1418 (see lib/engine.sh)
SEEDS=3
SCRIPT_NAME=ages.sh
COMPARE="stdout stderr exit"
setup() {
  local f
  mkdir dir1
  for f in a.txt "b c.txt" d.log e dir1; do
    [[ -e $f ]] || echo "$(word)" > "$f"
    touch -d "2025-0$(randr 1 3)-0$(randr 1 3) 10:00" "$f"
  done
}
ARGS=('a.txt "b c.txt" d.log e' 'e d.log "b c.txt" a.txt' 'a.txt nope "b c.txt" dir1' 'nope' '' 'd.log' 'a.txt a.txt' 'dir1 e a.txt')
extra_check() { ans_code | grep -qE -- '-nt|-ot' || fail "compare the files with -nt / -ot"; }
