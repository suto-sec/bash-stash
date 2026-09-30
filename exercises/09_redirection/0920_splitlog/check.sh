# checker spec for 0920 (see lib/engine.sh)
SCRIPT_NAME=splitlog.sh
SEEDS=3
COMPARE="stdout exit files errmsg"
mklog() {
  local i
  for i in $(seq "$1"); do
    case $(rand 12) in
      0) echo ;;
      1) echo "garbage $(word)" ;;
      *) printf '2024-06-%02d %02d:%02d:00 %s %s\n' "$(randr 1 30)" "$(rand 24)" "$(rand 60)" "$(pick ERROR WARN INFO DEBUG INFO error ERRORS FATAL WARNING)" "$(words "$(randr 1 4)")" ;;
    esac
  done
}
setup() {
  mklog 30 > app.log
  mklog 12 > "my app.log"
  mkdir out
  [[ $(rand 2) == 1 ]] && echo "2024-01-01 00:00:00 ERROR old line" > out/error.log
  [[ $(rand 2) == 1 ]] && echo "old other" > out/other.log
  touch notadir
}
ARGS=('app.log out' '"my app.log" "out dir"' 'app.log "$W/new/deep"' '"my app.log" out' '' 'app.log' 'a b c' 'nofile out' 'out out2' 'app.log notadir')
