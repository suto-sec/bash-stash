# checker spec for 0617 (see lib/engine.sh)
setup() {
  local i
  for i in $(seq 25); do echo "$i $(pick INFO ERROR error WARN WARNING DEBUG ERRORS Warn) $(words 2)"; done > app.log
  echo "26 WARN $(word)" >> app.log
}
