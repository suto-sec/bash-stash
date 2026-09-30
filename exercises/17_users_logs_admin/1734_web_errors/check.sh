# checker spec for 1734 (see lib/engine.sh)
SCRIPT_NAME=weberrors.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i ips=("$(ip_rand)" "$(ip_rand)" "$(ip_rand)" 10.0.71.7) ps=(/ /login /admin /.env /wp-login.php "/$(word)")
  for i in $(seq "$(randr 15 40)"); do
    echo "$(pick "${ips[@]}") - - [20/Jun/2026:10:00:$((10 + i)) +0200] \"GET $(pick "${ps[@]}") HTTP/1.1\" $(pick 200 200 301 304 400 403 404 404 500 503) $(randr 100 5000)"
  done > "access test.log"
  for i in 1 2 3; do echo "10.0.0.$i - - [20/Jun/2026:10:00:0$i +0200] \"GET / HTTP/1.1\" 200 512"; done > ok.log
  : > empty.log
}
ARGS=('"access test.log"' '"access test.log" 2' '"$W/access test.log" 100' '' '/var/log/apache2/access.log 3' 'ok.log' 'empty.log' 'noexiste' '"access test.log" 0' '"access test.log" x' 'a b c')
