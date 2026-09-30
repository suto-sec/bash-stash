# checker spec for 0534 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { [[ $(rand 3) != 0 ]] && randtext 3 | sed 's/^/INFO old /' > history.log; true; }
input() {
  local i n; n=$(randr 3 12)
  for ((i = 0; i < n; i++)); do
    echo "$(pick INFO WARN ERROR DEBUG ERROR) $(pick "$(words 3)" "no ERROR found" "ERRORS: $(word)")"
  done
}
extra_check() { must_use tee; }
