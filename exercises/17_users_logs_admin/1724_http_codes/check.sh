# checker spec for 1724 (see lib/engine.sh)
SCRIPT_NAME=httpcodes.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i
  mkdir -p "web logs"
  for i in $(seq "$(randr 5 30)"); do
    echo "$(ip_rand) - - [20/Jun/2026:09:$((10 + i)):00 +0200] \"GET /$(word) HTTP/1.1\" $(pick 200 200 301 404 403 500 304) $(pick "$(randr 100 9000)" "$(randr 10 99)" -)"
  done > "web logs/access.log"
  : > empty.log
}
ARGS=('' '"web logs/access.log"' 'empty.log' 'noexiste' 'a b')
