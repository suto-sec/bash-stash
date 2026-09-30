# checker spec for 1429 (see lib/engine.sh)
SCRIPT_NAME=config_check.sh
SEEDS=4
COMPARE="stdout exit errmsg"
setup() {
  local i
  mkdir logs "var log"; echo x > "log file"
  {
    echo "# $(word) settings"
    for ((i = 0; i < $(randr 6 11); i++)); do
      pick "port=$(randr 1 65535)" "port=$(pick 0 65536 08 80a '' ' 80')" "mode=$(pick on off On yes '')" \
           "name=$(word)" "name=$(pick "" "$(word) $(word)")" "logdir=$(pick logs "var log" "log file" nodir)" \
           "level=$(pick debug info warn error INFO trace)" "$(pick Port=80 "port = 80" =x "user=$(word)" "log-dir=logs" "just text")" \
           "" "# $(word)" "timeout=$(randr 1 60)"
    done
  } > "app.conf"
  printf '%s\n' "# good" "name=server1" "" "port=8080" "mode=on" "logdir=logs" "level=info" > good.conf
  printf '%s\n' "mode=off" "level=warn" "mode=on" "name=a=b" > partial.conf
  echo x > locked.conf; chmod 000 locked.conf
}
ARGS=('app.conf' 'good.conf' 'partial.conf' '"$W/app.conf"' '' 'a b' 'nofile' 'locked.conf' 'logs')
extra_check() {
  local tok
  if [[ $REF_CODE == 3 ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
