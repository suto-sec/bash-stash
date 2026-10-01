# checker spec for s38 step 2 (see lib/engine.sh)
SCRIPT_NAME=userlogins.sh
setup() {
  local i u
  for ((i = 0; i < 24; i++)); do
    u=$(pick ana luis eva ana ana)
    case $(rand 4) in
      0) echo "Mar $(randr 1 9) 1$(rand 10):00:$(randr 10 59) host sshd[$(randr 100 999)]: Failed password for $u from $(ip_rand) port 22" ;;
      1) echo "Mar $(randr 1 9) 1$(rand 10):00:$(randr 10 59) host sshd[$(randr 100 999)]: Failed password for invalid user bob from $(ip_rand) port 22" ;;
      *) echo "Mar $(randr 1 9) 1$(rand 10):00:$(randr 10 59) host sshd[$(randr 100 999)]: Accepted password for $u from $(ip_rand) port 22" ;;
    esac
  done > auth.log
  mkfl calm.log "Mar 1 10:00:00 host cron[1]: job started"
  : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *userlogins.sh* ]]; }
ARGS=('auth.log' 'calm.log' 'empty.log')
COMPARE="stdout exit"
