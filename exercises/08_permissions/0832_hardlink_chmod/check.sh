# checker spec for 0832 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  local content
  content=$(randtext 2)
  printf '%s\n' "$content" > a
  ln a b
  printf '%s\n' "$content" > c
  chmod "$(pick 755 700 644)" a
  chmod "$(pick 755 700 644)" c
}
extra_check() { must_use chmod; }
