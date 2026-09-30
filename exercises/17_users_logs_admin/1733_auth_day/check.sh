# checker spec for 1733 (see lib/engine.sh)
SCRIPT_NAME=dia.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d h ips=("$(ip_rand)" "$(ip_rand)" 45.33.32.156 45.33.32.15) ip
  for d in 1 2 3 8 9 10 11 12; do
    [[ $d != 1 && $d != 11 && $(rand 4) == 0 ]] && continue
    for h in $(seq 0 "$(randr 2 12)"); do
      ip=$(pick "${ips[@]}")
      printf 'Jun %2d %02d:%02d:%02d labhost ' "$d" "$h" "$(rand 60)" "$(rand 60)"
      case $(rand 6) in
        0|1) echo "sshd[1$h]: Failed password for $(pick root 'invalid user git') from $ip port 22 ssh2" ;;
        2) echo "sshd[1$h]: Accepted $(pick password publickey) for luke from $ip port 22 ssh2" ;;
        3) echo "sudo:   alumno : TTY=pts/0 ; PWD=/home/alumno ; USER=root ; COMMAND=/usr/bin/$(word)" ;;
        4) echo "sshd[1$h]: Invalid user $(word) from $ip port 22" ;;
        5) echo "CRON[1$h]: pam_unix(cron:session): session opened for user root(uid=0) by (uid=0)" ;;
      esac
    done
  done > "auth test.log"
}
ARGS=('1 "auth test.log"' '11 "auth test.log"' '8 "auth test.log"' '12 "$W/auth test.log"' '9 "auth test.log"' '20' '8 /var/log/auth.log' '5 "auth test.log"' '0 "auth test.log"' '32' '08 "auth test.log"' 'x' '3 noexiste' '' '1 2 3')
