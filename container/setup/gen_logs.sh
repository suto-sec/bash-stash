#!/bin/bash
# Deterministic fake system logs (classic syslog format, like older Ubuntu).
set -euo pipefail
RANDOM=2026
H=labhost

attackers=(185.220.101.47 185.220.101.47 185.220.101.47 185.220.101.47 185.220.101.47
           45.33.32.156 45.33.32.156 45.33.32.156 103.99.0.122 103.99.0.122
           61.177.172.13 61.177.172.13 61.177.172.13 218.92.0.34 5.188.10.176
           141.98.11.20 194.26.29.113 92.118.39.61)
bad_users=(admin root test oracle ubuntu pi guest user ftp postgres git support)
lan=(192.168.1.10 192.168.1.23 192.168.1.35 10.0.71.7)
good_users=(alumno luke sally jgarcia)
cmds=("/usr/bin/apt update" "/usr/bin/apt upgrade" "/usr/bin/systemctl restart cups"
      "/usr/bin/cat /etc/shadow" "/usr/sbin/adduser rmartin" "/usr/bin/tail -f /var/log/auth.log")

# Start: Jun  8 00:00:00 2026 ; end Jun 20 23:00 (single-digit days included on purpose)
t=$(date -d '2026-06-08 00:00:00' +%s)
end=$(date -d '2026-06-20 23:00:00' +%s)
pid=1200
out=/var/log/auth.log
: > "$out"
ts() { LC_ALL=C date -d "@$t" '+%b %e %H:%M:%S'; }

while (( t < end )); do
  t=$(( t + RANDOM % 900 + 30 ))
  pid=$(( pid + RANDOM % 40 + 1 ))
  r=$(( RANDOM % 100 ))
  port=$(( RANDOM % 30000 + 32000 ))
  if (( r < 45 )); then
    ip=${attackers[RANDOM % ${#attackers[@]}]}
    u=${bad_users[RANDOM % ${#bad_users[@]}]}
    if [[ $u == root ]]; then
      echo "$(ts) $H sshd[$pid]: Failed password for root from $ip port $port ssh2"
    else
      echo "$(ts) $H sshd[$pid]: Invalid user $u from $ip port $port"
      echo "$(ts) $H sshd[$pid]: Failed password for invalid user $u from $ip port $port ssh2"
    fi
    (( RANDOM % 3 == 0 )) && echo "$(ts) $H sshd[$pid]: Connection closed by $ip port $port [preauth]"
  elif (( r < 55 )); then
    ip=${attackers[RANDOM % ${#attackers[@]}]}
    echo "$(ts) $H in.telnetd[$pid]: connect from $ip ($ip)"
  elif (( r < 70 )); then
    ip=${lan[RANDOM % ${#lan[@]}]}
    u=${good_users[RANDOM % ${#good_users[@]}]}
    how=password; (( RANDOM % 2 )) && how=publickey
    echo "$(ts) $H sshd[$pid]: Accepted $how for $u from $ip port $port ssh2"
    echo "$(ts) $H sshd[$pid]: pam_unix(sshd:session): session opened for user $u(uid=$(id -u "$u")) by (uid=0)"
    t=$(( t + RANDOM % 600 ))
    echo "$(ts) $H sshd[$pid]: pam_unix(sshd:session): session closed for user $u"
  elif (( r < 80 )); then
    c=${cmds[RANDOM % ${#cmds[@]}]}
    echo "$(ts) $H sudo:   alumno : TTY=pts/0 ; PWD=/home/alumno ; USER=root ; COMMAND=$c"
    echo "$(ts) $H sudo: pam_unix(sudo:session): session opened for user root(uid=0) by alumno(uid=1000)"
    echo "$(ts) $H sudo: pam_unix(sudo:session): session closed for user root"
  elif (( r < 95 )); then
    echo "$(ts) $H CRON[$pid]: pam_unix(cron:session): session opened for user root(uid=0) by (uid=0)"
    echo "$(ts) $H CRON[$pid]: pam_unix(cron:session): session closed for user root"
  else
    ip=${lan[RANDOM % ${#lan[@]}]}
    echo "$(ts) $H sshd[$pid]: Failed password for alumno from $ip port $port ssh2"
  fi
done >> "$out"
# The last line mentions an IP (used by the "last IP in auth.log" exercises).
t=$(( t + 5 ))
echo "$(ts) $H sshd[$((pid+1))]: Failed password for invalid user admin from 185.220.101.47 port 40112 ssh2" >> "$out"

# older rotated log
head -n 300 "$out" > /var/log/auth.log.1
gzip -c /var/log/auth.log.1 > /var/log/auth.log.2.gz

# syslog / kern.log
{
  t=$(date -d '2026-06-20 08:00:00' +%s)
  for i in $(seq 1 400); do
    t=$(( t + RANDOM % 120 ))
    case $(( RANDOM % 6 )) in
      0) echo "$(ts) $H kernel: [$((RANDOM%9000)).$((RANDOM%999999))] UFW BLOCK IN=eth0 OUT= SRC=${attackers[RANDOM % ${#attackers[@]}]} DST=192.168.1.5 PROTO=TCP DPT=$((RANDOM%2 ? 22 : 23))" ;;
      1) echo "$(ts) $H systemd[1]: Started cron.service - Regular background program processing daemon." ;;
      2) echo "$(ts) $H cron[$((RANDOM%900+100))]: (CRON) INFO (Running @reboot jobs)" ;;
      3) echo "$(ts) $H NetworkManager[812]: <info>  [$t.1234] dhcp4 (eth0): state changed new lease, address=192.168.1.5" ;;
      4) echo "$(ts) $H kernel: [$((RANDOM%9000)).$((RANDOM%999999))] usb 1-1: new high-speed USB device number $((RANDOM%9)) using xhci_hcd" ;;
      5) echo "$(ts) $H systemd[1]: Starting apt-daily.service - Daily apt download activities..." ;;
    esac
  done
} > /var/log/syslog
grep ' kernel: ' /var/log/syslog > /var/log/kern.log

# apache-style access log in a subdirectory
mkdir -p /var/log/apache2
{
  t=$(date -d '2026-06-20 09:00:00' +%s)
  paths=(/ /index.html /login /admin /wp-login.php /.env /images/logo.png /api/v1/users)
  codes=(200 200 200 404 403 301 500)
  for i in $(seq 1 300); do
    t=$(( t + RANDOM % 60 ))
    if (( RANDOM % 3 )); then ip=${lan[RANDOM % ${#lan[@]}]}; else ip=${attackers[RANDOM % ${#attackers[@]}]}; fi
    d=$(LC_ALL=C date -d "@$t" '+%d/%b/%Y:%H:%M:%S +0200')
    echo "$ip - - [$d] \"GET ${paths[RANDOM % ${#paths[@]}]} HTTP/1.1\" ${codes[RANDOM % ${#codes[@]}]} $((RANDOM % 5000 + 200))"
  done
} > /var/log/apache2/access.log
echo "AH00558: apache2: Could not reliably determine the server's fully qualified domain name" > /var/log/apache2/error.log

chown root:adm /var/log/auth.log* /var/log/syslog /var/log/kern.log /var/log/apache2/*
chmod 640 /var/log/auth.log* /var/log/syslog /var/log/kern.log /var/log/apache2/*

# login history for `last` (wtmp) and live sessions for `who` (utmp, restored at start)
mk_utmp() { # type pid id user line host epoch
  printf '[%d] [%05d] [%-4s] [%-8s] [%-12s] [%-20s] [%-15s] [%s]\n' "$1" "$2" "$3" "$4" "$5" "$6" "0.0.0.0" \
    "$(date -u -d "@$7" '+%Y-%m-%dT%H:%M:%S,000000+00:00')"
}
{
  mk_utmp 7 2101 ts/4 pruiz pts/4 31.4.92.145 "$(date -d '2026-06-12 07:44' +%s)"
  mk_utmp 8 2101 ts/4 ""       pts/4 ""          "$(date -d '2026-06-12 07:48' +%s)"
  mk_utmp 7 2210 ts/3 pruiz pts/3 10.0.71.7   "$(date -d '2026-06-15 17:08' +%s)"
  mk_utmp 8 2210 ts/3 ""       pts/3 ""          "$(date -d '2026-06-15 19:47' +%s)"
  mk_utmp 7 2300 tty1 pruiz tty1  ""          "$(date -d '2026-06-18 10:53' +%s)"
  mk_utmp 7 2410 ts/0 luke     pts/0 ":0"        "$(date -d '2026-06-19 15:16' +%s)"
  mk_utmp 7 2411 ts/7 sally    pts/7 callisto    "$(date -d '2026-06-20 13:00' +%s)"
  mk_utmp 7 2412 ts/9 rod      pts/9 remote.example.org "$(date -d '2026-06-20 13:22' +%s)"
} > /opt/lab-setup/wtmp.txt
{
  mk_utmp 7 2300 tty1 pruiz tty1  ""          "$(date -d '2026-06-18 10:53' +%s)"
  mk_utmp 7 2410 ts/0 luke     pts/0 ":0"        "$(date -d '2026-06-19 15:16' +%s)"
  mk_utmp 7 2411 ts/7 sally    pts/7 callisto    "$(date -d '2026-06-20 13:00' +%s)"
  mk_utmp 7 2412 ts/9 rod      pts/9 remote.example.org "$(date -d '2026-06-20 13:22' +%s)"
} > /opt/lab-setup/utmp.txt
utmpdump -r < /opt/lab-setup/wtmp.txt > /var/log/wtmp 2>/dev/null || true
