# checker spec for 1222 (see lib/engine.sh)
SCRIPT_NAME=multi_signal_report.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('' 'TERM,KILL' 'HUP' 'TERM,KILL,HUP,USR1,USR2' 'BOGUS' 'TERM,,KILL' 'term' 'TERM KILL' 'USR1,USR2,TERM,HUP')
extra_check() {
  if [[ $REF_CODE == 3 ]]; then
    eval "set -- $CASE"
    local bad= tok
    local IFS=,
    for tok in $1; do
      case $tok in TERM|KILL|HUP|USR1|USR2) ;; *) bad=$tok; break ;; esac
    done
    mentions "$bad"
  fi
}
