# checker spec for 1019 (see lib/engine.sh)
setup() {
  mkdir -p "proj/src/lib" "proj/my docs" proj/empty
  local i
  for i in $(seq "$(randr 3 8)"); do
    bigfile "proj/$(pick . src src/lib 'my docs')/$(word)$(pick '' ' ' '.')$i" $(( $(randr 1 60) * 37 + i ))
  done
  [[ $(rand 2) == 1 ]] && mkdir -p "proj/extra dir/deep"
  true
}
extra_check() { ans_code | grep -q '\$(' || fail "use command substitution \$( )"; }
