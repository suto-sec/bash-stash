# checker spec for 1520 (see lib/engine.sh)
SEEDS=4
setup() {
  local i
  for i in $(seq "$(randr 5 11)"); do
    case $(rand 7) in
      0) echo "# $(words 3)" ;;
      1) echo ;;
      2) echo "$(words 2)" ;;
      3) echo "=$(word)" ;;
      4) echo "$(word)=" ;;
      5) echo "$(word)=$(word)=$(word)" ;;
      *) echo "$(word)=$(words "$(randr 1 3)")" ;;
    esac
  done > app.conf
}
extra_check() { must_use read; }
