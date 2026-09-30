# checker spec for 0550 (see lib/engine.sh)
SCRIPT_NAME=leaderboard.sh
SEEDS=3
COMPARE="stdout exit errmsg"
ARGS=('scores.csv' 'scores.csv 5' 'scores.csv 50' '"cup 2026.csv" 2' 'scores.csv 1' '' 'scores.csv 3 x' 'nofile.csv' 'scores.csv 0' 'scores.csv three')
setup() {
  local i n
  n=$(randr 8 20)
  { echo "player;game;score"
    for ((i = 1; i <= n; i++)); do
      echo "$(pick Ana "Ana Maria" Anabel Luis Marta Diego Eva "Jon Ander");$(pick chess tetris pong);$(pick 0 50 120 300 300 450 999 $(randr 1 999))"
    done
  } > scores.csv
  n=$(randr 2 6)
  { echo "player;game;score"
    for ((i = 1; i <= n; i++)); do echo "$(pick Iker Nerea Sara);final;$(pick 10 20 20)"; done
  } > "cup 2026.csv"
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *leaderboard.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
