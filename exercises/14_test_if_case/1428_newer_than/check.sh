# checker spec for 1428 (see lib/engine.sh)
SCRIPT_NAME=newer_than.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i f d dates=("2025-01-10 10:00" "2025-02-10 10:00" "2025-03-10 10:00")
  mkdir -p "project/src" "project/doc s/old" "project/empty"
  for d in project "project/src" "project/doc s" "project/doc s/old"; do
    for ((i = 1; i <= $(randr 1 3); i++)); do
      f="$d/$(pick "$(word)$i" "my $(word)$i").$(pick txt c md)"
      echo "$i" > "$f"; touch -d "$(pick "${dates[@]}")" "$f"
    done
  done
  echo r > "project/doc s/ref.txt"; touch -d "${dates[1]}" "project/doc s/ref.txt"
  echo s > stamp; touch -d "$(pick "${dates[@]}")" stamp
  ln -s "doc s/ref.txt" "project/link.txt"
  mkdir "project/dir.txt"; touch -d "2025-02-10 10:00" "project/dir.txt"
}
ARGS=('stamp project' '"project/doc s/ref.txt" project' '"project/doc s/ref.txt" "$W/project"' 'stamp "project/doc s"' 'stamp project/empty' 'nostamp project' 'stamp stamp' 'stamp nodir' '' 'stamp' 'a b c')
extra_check() {
  local tok
  if [[ $REF_CODE == [23] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
