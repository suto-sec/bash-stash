# checker spec for s60 step 1 (see lib/engine.sh)
SCRIPT_NAME=cronlog.sh
setup() {
  local i u
  for ((i = 0; i < 24; i++)); do
    u=$(pick root root ana luis)
    echo "Mar $(randr 1 9) 0$(rand 10):$(randr 10 59):01 host CRON[$(randr 100 999)]: ($u) CMD ($(pick /usr/bin/backup /opt/clean.sh /usr/bin/report))"
  done > cron.log
  echo "Mar 1 01:00:00 host kernel: something else" >> cron.log
  mkfl calm.log "Mar 1 01:00:00 host kernel: only kernel lines"
  : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *cronlog.sh* ]]; }
ARGS=('cron.log' 'calm.log' 'empty.log')
COMPARE="stdout exit"
