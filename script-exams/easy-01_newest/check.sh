# checker spec for the practice exam easy-01 (see lib/engine.sh; graded by objectives with bin/sgrade)
SCRIPT_NAME=newest.sh
OBJECTIVES=(
  "args|Argument checking and error messages|3"
  "core|Finding and printing the newest file|4"
  "edge|Special cases (spaces, hidden files, no files)|3"
)
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i f off n=0
  mkdir -p docs/sub "mixed dir" onlydirs/a onlydirs/b empty
  off=$(rand 5)
  for i in 1 2 3 4 5; do
    n=$((n + 1)); f="docs/$(word)$n.txt"
    head -c "$(randr 1 300)" /dev/zero | tr '\0' 'x' > "$f"
    touch -d "@$((1700000000 + (((i + off) % 5) + 1) * 86400 + $(rand 3600)))" "$f"
  done
  touch -d "@1600000000" docs/sub
  for f in "a file.txt" "b file.log" ".hidden one" "plain.txt"; do
    head -c "$(randr 1 200)" /dev/zero | tr '\0' 'y' > "mixed dir/$f"
  done
  touch -d "@1700100000" "mixed dir/a file.txt" "mixed dir/b file.log" "mixed dir/plain.txt"
  touch -d "@1700200000" "mixed dir/.hidden one"            # the newest file is hidden and has spaces
  mkdir "mixed dir/new sub"; touch -d "@1700250000" "mixed dir/new sub"   # a directory newer than every file
  touch -d "@1700300000" "mixed dir"
  touch -d "@1700400000" onlydirs/a
  for f in top1.txt top2.txt .top3; do head -c "$(randr 1 50)" /dev/zero | tr '\0' 'z' > "$f"; done
  touch -d "@1700010000" top1.txt top2.txt; touch -d "@1700020000" .top3
  echo x > notadir.txt
}
ARGS=('docs' '"$W/docs"' 'docs/' '' '"mixed dir"' 'onlydirs' 'empty' 'nodir' 'notadir.txt' 'docs docs' '"mixed dir" extra arg')
CASE_OBJ=(core core core core edge edge edge args args args args)
extra_check() {
  if [[ $REF_CODE == [123] ]]; then
    [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
    [[ $REF_CODE == 1 ]] && { [[ $ERR == *newest.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script"; }
  fi
}
