# checker spec for 1023 (see lib/engine.sh)
setup() {
  local dirs=(. src "src/my lib" "/etc" "$(word) dir" docs/old) i d
  for i in $(seq "$(randr 6 14)"); do
    d=$(pick "${dirs[@]}")
    if [[ $d == . ]]; then echo "$(word)$i.txt"; else echo "$d/$(word)$(pick '' ' ')$i.$(pick c h txt)"; fi
  done > paths.txt
}
