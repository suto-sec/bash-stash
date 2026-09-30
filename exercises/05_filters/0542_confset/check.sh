# checker spec for 0542 (see lib/engine.sh)
SCRIPT_NAME=confset.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
ARGS=('app.cfg PORT 8080' 'app.cfg HOST' 'app.cfg DEBUG true' 'app.cfg NEW_KEY "a b/c:d"' '"my app.cfg" PATH_DIR /opt/x' 'app.cfg PORT' 'app.cfg PATH_DIR' 'app.cfg DEBUG' 'app.cfg NOPE' 'app.cfg' '' 'app.cfg PORT 1 extra' 'nofile.cfg PORT 1' 'app.cfg 9bad x' 'app.cfg BAD-KEY')
setup() {
  { echo "# app configuration"
    echo "# PORT is the listening port"
    echo "MYPORT=$(randr 1000 9999)"
    echo "PORT=$(randr 1000 9999)"
    echo "PORT2=$(randr 1000 9999)"
    echo "HOST=$(word).example.com"
    [[ $(rand 2) == 0 ]] && echo "#HOST=old.example.com"
    echo "#DEBUG=false"
    echo "NAME=$(word) $(word)"
    echo "PATH_DIR=/srv/$(word)"
    [[ $(rand 2) == 0 ]] && echo "PORT=$(randr 1000 9999)"
    echo "LOG_LEVEL=$(pick info warn)"
  } > app.cfg
  { echo "# $(word)"
    echo "#PATH_DIR=/tmp"
    echo "USER=$(word)"
  } > "my app.cfg"
}
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *confset.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3|4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
