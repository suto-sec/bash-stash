# checker spec for s72 step 4 (see lib/engine.sh)
SCRIPT_NAME=iplog.sh
setup() {
  mkdir -p logs/sub empty "my logs"
  local f i
  for f in web mail ssh; do
    for ((i = 0; i < 14; i++)); do
      echo "Oct $((1 + i)) 10:0$((i % 10)):00 host $f: from $(pick 10.0.0.5 10.0.0.5 10.0.0.50 192.168.1.7 172.16.0.9) request $i"
    done > logs/$f.log
  done
  echo "quiet" > logs/quiet.log; echo "from 10.0.0.5 in a text file" > logs/notes.txt
  echo "from 10.0.0.5 below" > logs/sub/deep.log; cp logs/web.log "my logs/web.log"
  for ((i = 0; i < 20; i++)); do
    echo "Oct 1 11:$((10 + i)):00 host sshd[$((100 + i))]: Failed password for root from $(pick 10.0.0.5 10.0.0.5 10.0.0.50 192.168.1.7 8.8.4.4) port $((2000 + i)) ssh2"
  done > "$HOME/auth.log"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *iplog.sh* ]]; }
ARGS=('logs 10.0.0.5' '10.0.0.5' 'logs' '"my logs" 192.168.1.7' '' 'logs 10.0.0.5 extra' 'notadir.txt 10.0.0.5' 'nothing 10.0.0.5' 'logs notanip' 'logs 10.0.0' 'notanip' 'notadir.txt' 'nothing' '10.0.0.5 $(rm -f $H/auth.log)' 'logs $(rm -f $H/auth.log)')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  local a; a=$(eval "set -- $CASE"; echo "$#|$1|$2")
  [[ $REF_CODE == 2 ]] && mentions "auth.log"
  [[ $REF_CODE == 3 ]] && { a=${a#*|}; mentions "${a%%|*}"; }
  if [[ $REF_CODE == 4 ]]; then local n=${a%%|*}; a=${a#*|}; if [[ $n == 1 ]]; then mentions "${a%%|*}"; else mentions "${a#*|}"; fi; fi
}
