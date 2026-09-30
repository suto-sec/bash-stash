# checker spec for 1425 (see lib/engine.sh)
SCRIPT_NAME=safe_copy.sh
SEEDS=4
COMPARE="stdout exit errmsg files"
setup() {
  local n
  mkdir out
  for n in a.txt "b c.txt" d.txt; do
    words 3 > "$n"; touch -d "2025-03-10 10:00" "$n"
    case $(rand 4) in
      1) cp "$n" "out/$n"; touch -d "2025-0$(pick 1 6)-01 10:00" "out/$n" ;;
      2) words 2 > "out/$n"; touch -d "2025-01-01 10:00" "out/$n" ;;
      3) words 2 > "out/$n"; touch -d "2025-06-01 10:00" "out/$n" ;;
    esac
  done
  echo s > locked.txt; chmod 000 locked.txt
}
ARGS=('a.txt out' '"b c.txt" out' 'd.txt out' '-f d.txt out' '-f "b c.txt" out' 'a.txt "out/a.txt"' 'a.txt new.txt' 'a.txt nodir/x.txt' 'nope out' 'out a.txt' 'locked.txt out' 'a.txt a.txt' 'a.txt .' '' 'a' '-f a' '-f a b c' '"$W/b c.txt" "$W/out"')
extra_check() {
  local tok
  if [[ $REF_CODE == [2345] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
