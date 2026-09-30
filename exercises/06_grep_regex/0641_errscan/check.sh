# checker spec for 0641 (see lib/engine.sh)
SCRIPT_NAME=errscan.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('s1.log s2.log s3.log' 's2.log' 's3.log' 's1.log s3.log' '' 's1.log nofile.log' 'nofile.log s2.log')
setup() {
  local i
  : > s1.log
  for i in $(seq "$(randr 3 6)"); do echo "$(pick ok fine "$(word)")" >> s1.log; done
  echo "ERROR $(word)" >> s1.log
  : > s2.log
  for i in $(seq "$(randr 2 5)"); do echo "$(word)" >> s2.log; done
  echo "CRITICAL $(word)" >> s2.log
  echo "CRITICAL $(word)" >> s2.log
  : > s3.log
  for i in $(seq "$(randr 2 4)"); do echo "$(word) $(word)" >> s3.log; done
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *errscan.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) [[ $CASE == nofile* ]] && mentions nofile.log
       [[ $CASE == *nofile.log ]] && mentions nofile.log ;;
  esac
}
