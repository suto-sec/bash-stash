# checker spec for 0918 (see lib/engine.sh)
COMPARE="stdout stderr exit files"
setup() {
  mkdir datos
  local i
  for i in $(seq "$(randr 1 5)"); do touch "datos/$(word)$i.$(pick txt log)"; done
  [[ $(rand 2) == 1 ]] && echo "old log line" > script.log
  true
}
extra_check() { ans_code | grep -q 'exec' || fail "use exec to redirect the rest of the script"; }
