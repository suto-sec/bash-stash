# checker spec for 0727 (see lib/engine.sh)
setup() {
  mkdir -p logs/app "logs/web server" logs/db/old logs/empty
  local i
  for i in $(seq "$(randr 8 16)"); do
    touch "logs/$(pick . app 'web server' db db/old app)/$(word)$(pick '' ' ')$i$(pick .log .log .log .txt .log.1)"
  done
  mkdir -p logs/dir.log
}
