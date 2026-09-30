# checker spec for 0634 (see lib/engine.sh)
SCRIPT_NAME=sshlogins.sh
SEEDS=2
COMPARE="stdout exit errmsg"
mklog() {
  local i ips=("$(ip_rand)" "$(ip_rand)" 10.0.0.1 10.0.0.12)
  for i in $(seq "$1"); do
    printf 'Jun %2d %02d:%02d:%02d labhost ' "$(randr 1 30)" "$(rand 24)" "$(rand 60)" "$(rand 60)"
    case $(rand 8) in
      0) echo "sshd[$(randr 900 9999)]: Failed password for $(pick alice bob root) from $(pick "${ips[@]}") port $(randr 1024 65000) ssh2" ;;
      1) echo "sshd[$(randr 900 9999)]: Failed password for invalid user $(pick admin test) from $(pick "${ips[@]}") port $(randr 1024 65000) ssh2" ;;
      2) echo "sshd[$(randr 900 9999)]: Accepted keyboard-interactive/pam for carol from $(pick "${ips[@]}") port $(randr 1024 65000) ssh2" ;;
      3) echo "sudo: $(pick alice bob) : TTY=pts/0 ; PWD=/home/x ; USER=root ; COMMAND=/bin/ls" ;;
      4) echo "CRON[$(randr 900 9999)]: Accepted password for root from 1.1.1.1 port 22 (fake)" ;;
      *) echo "sshd[$(randr 900 9999)]: Accepted $(pick password publickey publickey) for $(pick alice bob carol dave deploy) from $(pick "${ips[@]}") port $(randr 1024 65000) ssh2" ;;
    esac
  done
}
setup() { mklog 40 > auth.log; mklog 15 > "old auth.log"; grep -v Accepted auth.log > failed.log; true; }
ARGS=('auth.log' 'auth.log password' '"old auth.log" publickey' '/var/log/auth.log publickey' 'auth.log all'
      'failed.log' '' 'a b c' 'nofile' 'auth.log ssh' 'auth.log Password')
