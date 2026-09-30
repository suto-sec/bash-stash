# checker spec for 0636 (see lib/engine.sh)
SCRIPT_NAME=ini.sh
SEEDS=3
COMPARE="stdout exit errmsg"
mkini() {
  echo "; generated $(word)"
  echo "[server]"
  echo "host = $(word).example.com"
  [[ $(rand 2) == 1 ]] && echo "  port=$(randr 1000 9999)"
  echo "# $(words 2)"
  printf '\t\n'
  echo "name   =   $(words 2)   "
  [[ $(rand 2) == 1 ]] && echo "url = http://x/?a=$(word)&b=1"
  echo "verbose"
  echo "[server-old]"
  echo "host = old$(randr 1 9)"
  echo "[db.main]"
  echo "user = $(word)"
  echo "  ; pass = secret"
  echo "pass="
  [[ $(rand 2) == 1 ]] && echo "timeout=$(randr 1 60)"
  echo "[dbxmain]"
  echo "user = decoy"
  echo "[empty]"
  echo "; nothing here"
  echo
  echo "[local paths]"
  echo "data = /srv/$(word) dir"
  echo " [logging]"
  echo "level = $(pick info debug warn)"
  echo "[logging]"
  echo "file= /var/log/$(word).log"
}
setup() { mkini > app.ini; mkini > "my conf.ini"; }
ARGS=('app.ini server' '"my conf.ini" db.main' 'app.ini empty' 'app.ini "local paths"' 'app.ini logging'
      'app.ini nope' 'app.ini db' '' 'app.ini' 'a b c' 'nofile server' '. server')
extra_check() { [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"; true; }
