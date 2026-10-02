# checker spec for s72 step 1 (see lib/engine.sh)
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
ARGS=('logs 10.0.0.5' 'logs 10.0.0.50' 'logs 192.168.1.7' 'logs 172.16.0.9' 'logs 8.8.8.8' '"my logs" 10.0.0.5' 'empty 10.0.0.5')
COMPARE="stdout exit"
