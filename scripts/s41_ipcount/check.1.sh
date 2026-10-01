# checker spec for s41 step 1 (see lib/engine.sh)
SCRIPT_NAME=ipcount.sh
setup() {
  local i ip
  for ((i = 0; i < 40; i++)); do
    ip=$(pick 10.0.0.1 10.0.0.1 10.0.0.2 10.0.0.3 172.16.0.9 192.168.1.5 192.168.1.5 192.168.1.5)
    echo "$ip - $(pick GET POST) /$(word) $(pick 200 200 404 500)"
  done > access.log
  mkfl small.log "10.0.0.2 - GET /a 200" "10.0.0.2 - GET /b 200" "192.168.1.5 - GET /c 404"
  : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *ipcount.sh* ]]; }
ARGS=('access.log' 'small.log' 'empty.log')
COMPARE="stdout exit"
