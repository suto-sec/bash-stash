# checker spec for 1802 (see lib/engine.sh)
SCRIPT_NAME=ipLog.sh
SEEDS=2
setup() {
  mkdir -p logs/sub "logs/con espacio"
  local ips=(185.220.101.47 45.33.32.156 10.0.0.1 192.168.1.10 "$(ip_rand)") f i
  for f in logs/a.log logs/sub/b.log "logs/con espacio/c d.log" logs/notes.txt logs/old.log.1 logs/sub/e.log; do
    for i in $(seq "$(randr 2 6)"); do echo "$(word) $(pick "${ips[@]}" "${ips[0]}5" "1${ips[2]}" '') $(word)"; done > "$f"
  done
  mkdir logs/dir.log
  touch fichero.txt
}
ARGS=('' '185.220.101.47' '192.168.1.10' '8.8.8.8' 'logs' '"$W/logs"' 'logs/sub' 'logs 45.33.32.156' '"$W/logs" 10.0.0.1' 'logs 185.220.101.47' 'noexiste' 'fichero.txt' 'logs 999.1.1.1' 'logs 1.2.3' 'nodir 1.2.3.4' 'a b c')
filter() { sed -E 's/^Date: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$/Date: <date ok>/'; }
extra_check() { [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"; true; }
