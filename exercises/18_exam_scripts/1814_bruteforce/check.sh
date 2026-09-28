# checker spec for 1814 (see lib/engine.sh)
SCRIPT_NAME=bruteforce.sh
COMPARE="stdout exit errmsg"
setup() { local i ips=("$(ip_rand)" "$(ip_rand)" "$(ip_rand)" 10.0.0.1); for i in $(seq 40); do echo "Jun 20 10:00:$i host sshd[1]: $(pick 'Failed password for root' 'Accepted password for alumno' 'Failed password for invalid user admin') from $(pick "${ips[@]}" "${ips[0]}") port 22 ssh2"; done > fake.log; }
ARGS=('' 'fake.log' 'fake.log 3' 'fake.log 100' '/var/log/auth.log 300' 'noexiste.log' 'fake.log 0' 'fake.log x' 'a b c')
