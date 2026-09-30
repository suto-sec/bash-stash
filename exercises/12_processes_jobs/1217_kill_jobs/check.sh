# checker spec for 1217 (see lib/engine.sh)
SCRIPT_NAME=kill_jobs.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('' '%1' '%2 %3' 'all' '%1 %1' '%9' '%2 bogus' '%0')
extra_check() {
  if [[ $REF_CODE == 2 ]]; then
    local bad=
    eval "set -- $CASE"
    for a in "$@"; do
      case $a in %1|%2|%3|all) ;; *) bad=$a; break ;; esac
    done
    mentions "$bad"
  fi
}
