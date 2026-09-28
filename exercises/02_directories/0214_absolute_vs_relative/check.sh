# checker spec for 0214 (see lib/engine.sh)
setup() {
  local a b c; a=$(word)1 b=$(word)2 c=$(word)3
  mkdir -p "$a/$b/$c" "$a/tmp"
  pick "$a/tmp/../$b/$c" "$a/$b/./$c" "$a/$b" "$a/tmp/../$b/$c/../$c" "$a" > where.txt
}
