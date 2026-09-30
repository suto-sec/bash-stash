# checker spec for 1218 (see lib/engine.sh)
SCRIPT_NAME=signal_sender.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('' 'TERM' 'TERM 3' 'BOGUS 2' 'TERM abc' 'TERM 0' 'TERM 10' 'HUP 1' 'USR1 5' 'TERM 2 x')
extra_check() {
  if [[ $REF_CODE == 2 ]]; then eval "set -- $CASE"; mentions "$1"; fi
}
