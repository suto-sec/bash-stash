# checker spec for 1527 (see lib/engine.sh)
SEEDS=5
COMPARE="stdout exit errmsg"
input() {
  local i
  for i in $(seq "$(randr 0 7)"); do
    case $(rand 8) in
      0) echo "$(word)" ;; 1) echo "$(word) abc" ;; 2) echo "$(word) $(randr 101 200)" ;;
      3) echo "$(word) 5 $(word)" ;; 4) echo ;; *) echo "$(word) $(randr 0 100)" ;;
    esac
  done
}
extra_check() { must_use read printf; }
