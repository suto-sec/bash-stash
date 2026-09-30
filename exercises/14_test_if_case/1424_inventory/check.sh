# checker spec for 1424 (see lib/engine.sh)
SCRIPT_NAME=inventory.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d="my stuff" i f
  mkdir "$d"
  for ((i = 1; i <= $(randr 2 5); i++)); do
    f="$d/$(pick "$(word)$i" "my $(word)$i").$(pick txt sh log)"
    randtext 2 > "$f"; chmod "$(pick 644 755 600 700 311 000)" "$f"
  done
  : > "$d/empty$(rand 9)"
  [[ $(rand 2) == 1 ]] && { : > "$d/run empty"; chmod 755 "$d/run empty"; }
  mkdir "$d/sub dir" "$d/.cache"
  echo x > "$d/.hidden"
  ln -s "sub dir" "$d/to sub"
  ln -s "nothere$(rand 9)" "$d/broken$(rand 9)"
  [[ $(rand 2) == 1 ]] && ln -s ".hidden" "$d/link to hidden"
  mkfifo "$d/pipe"
  echo t > file.txt
  mkdir locked; chmod 000 locked
}
ARGS=('"my stuff"' '' '"$W/my stuff"' 'nodir' 'file.txt' 'locked' '"my stuff" file.txt')
extra_check() {
  local tok
  if [[ $REF_CODE == [234] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
