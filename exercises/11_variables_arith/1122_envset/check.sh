# checker spec for 1122 (see lib/engine.sh)
SCRIPT_NAME=envset.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i n=$(randr 5 8)
  : > cfg.txt
  for i in $(seq "$n"); do
    case $(rand 6) in
      0) echo "" >> cfg.txt ;;
      1) echo "# $(words 3)" >> cfg.txt ;;
      2) echo "no_equals_$(word)" >> cfg.txt ;;
      3) echo "1BAD=$(word)" >> cfg.txt ;;
      4) echo "BAD-KEY=$(word)" >> cfg.txt ;;
      *) echo "VAR_$(word)_$i=$(words 2)" >> cfg.txt ;;
    esac
  done
  echo "VAR_ALPHA=$(word)" >> cfg.txt
  echo "VAR_BETA=$(word) $(word)" >> cfg.txt
  echo "OTHER_GAMMA=$(word)" >> cfg.txt
}
ARGS=('cfg.txt' 'cfg.txt VAR_' 'cfg.txt OTHER_' 'cfg.txt 1BAD' '' 'cfg.txt VAR_ extra' 'noexiste.txt')
extra_check() {
  [[ $REF_CODE != 0 && -z $ERR ]] && fail "expected an error message on stderr"
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sage* || $ERR == *envset* ]] || fail "the usage message should show how to call the script"; }
  true
}
