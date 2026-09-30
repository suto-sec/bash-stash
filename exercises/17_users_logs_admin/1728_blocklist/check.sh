# checker spec for 1728 (see lib/engine.sh)
SCRIPT_NAME=blocklist.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i ips=("$(ip_rand)" "$(ip_rand)" "$(ip_rand)" 10.0.0.1 10.0.0.11 192.168.1.10) ip
  mkdir -p "mis logs"
  for i in $(seq 10 70); do
    ip=$(pick "${ips[@]}" "${ips[0]}" "${ips[3]}")
    case $(rand 4) in
      0|1) echo "Jun 20 10:$i:01 labhost sshd[$i]: Failed password for $(pick root 'invalid user admin' alumno) from $ip port 4$i ssh2" ;;
      2) echo "Jun 20 10:$i:02 labhost sshd[$i]: Accepted password for luke from $ip port 4$i ssh2" ;;
      3) echo "Jun 20 10:$i:03 labhost sshd[$i]: Invalid user test from $ip port 4$i" ;;
    esac
  done > auth.log
  cp auth.log "mis logs/auth 2.log"
  printf '%s\n' "# trusted" 192.168.1.10 "$(pick "${ips[1]}" 10.0.0.11 1.1.1.1)" > white.txt
  if [[ $(rand 2) == 1 ]]; then printf '%s\n' 8.8.8.8 "$(pick "${ips[0]}" "${ips[2]}" 10.0.0.11)" > "$H/blocklist.txt"; fi
  true
}
ARGS=('auth.log white.txt' 'auth.log white.txt 3' '"mis logs/auth 2.log" white.txt 1' '"$W/auth.log" "$W/white.txt" 12' '/var/log/auth.log white.txt 150' 'noexiste.log white.txt' 'auth.log nowhite.txt' 'auth.log white.txt 0' 'auth.log white.txt x3' 'auth.log' 'a b c d')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions noexiste.log
  [[ $REF_CODE == 3 ]] && mentions nowhite.txt
  true
}
