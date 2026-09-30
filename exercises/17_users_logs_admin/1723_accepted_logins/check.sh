# checker spec for 1723 (see lib/engine.sh)
SCRIPT_NAME=logins.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i u us=("$(word)" "$(word)" "$(word)" luke) ips=("$(ip_rand)" "$(ip_rand)" 10.0.71.7)
  for i in $(seq 10 40); do
    u=$(pick "${us[@]}")
    case $(rand 5) in
      0|1) echo "Jun 20 10:$i:01 labhost sshd[$i]: Accepted $(pick password publickey) for $u from $(pick "${ips[@]}") port 4$i ssh2" ;;
      2) echo "Jun 20 10:$i:02 labhost sshd[$i]: Failed password for $u from $(pick "${ips[@]}") port 4$i ssh2" ;;
      3) echo "Jun 20 10:$i:03 labhost sshd[$i]: pam_unix(sshd:session): session opened for user $u(uid=1001) by (uid=0)" ;;
      4) echo "Jun 20 10:$i:04 labhost CRON[$i]: pam_unix(cron:session): session closed for user root" ;;
    esac
  done > "auth fake.log"
  echo "Jun 20 11:00:00 labhost sshd[9]: Failed password for root from 1.2.3.4 port 22 ssh2" > none.log
}
ARGS=('' '"auth fake.log"' 'none.log' 'noexiste.log' 'a b')
