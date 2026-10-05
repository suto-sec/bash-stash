# checker spec for the practice exam medium-03 (see lib/engine.sh; graded by objectives with bin/sgrade)
SCRIPT_NAME=svcerrors.sh
OBJECTIVES=(
  "args|Argument checking and error messages|3"
  "core|Selecting, counting and ordering the services|4"
  "edge|Special cases (no match, odd lines, words inside messages)|3"
)
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i svc lv
  local svcs=(sshd cron nginx-proxy kernel db2 mailer)
  local lvls=(ERROR INFO WARN ERROR ERROR INFO)
  for ((i = 1; i <= 40; i++)); do
    svc=$(pick "${svcs[@]}"); lv=$(pick "${lvls[@]}")
    printf '2026-03-%02d %02d:%02d:%02d %s %s: %s %s\n' "$(randr 1 28)" "$(randr 0 23)" "$(randr 0 59)" "$(randr 0 59)" "$lv" "$svc" "$(word)" "$(word)"
  done > main.log
  cat > tricky.log <<'EOT'
2026-03-01 08:00:00 ERROR sshd: login failed: user root from 10.0.0.5
-- log rotated --

2026-03-01 08:00:01 INFO cron: retry after ERROR 5
2026-03-01 08:00:02 ERROR db2: connection lost
2026-03-01 08:00:03 ERRORS db2: not a level
2026-03-01 08:00:04 ERROR sshd: too many failures
2026-03-01 08:00:05 WARN db2: slow query ERROR in text
2026-03-01 08:00:06 ERROR mailer: queue full
2026-03-01 08:00:07 ERROR mailer: queue full again
2026-03-01 08:00:08 ERROR kernel: oops

garbage line without structure
2026-03-01 08:00:09 error sshd: lower case level
EOT
  cat > quiet.log <<'EOT'
2026-03-02 10:00:00 INFO sshd: started
2026-03-02 10:00:01 INFO cron: job ok
2026-03-02 10:00:02 WARN sshd: slow
-- end --
EOT
  : > empty.log
  cp main.log locked.log; chmod 000 locked.log
  mkdir -p adir
}
ARGS=('' 'main.log WARN extra' 'nofile.log' 'adir' 'locked.log' 'main.log DEBUG' 'main.log error' 'nofile.log DEBUG'
      'main.log' 'main.log WARN' 'main.log INFO' 'tricky.log' 'tricky.log ERROR'
      'quiet.log' 'quiet.log WARN' 'quiet.log ERROR' 'empty.log' 'tricky.log INFO' 'tricky.log WARN')
CASE_OBJ=(args args args args args args args args  core core core core core  edge edge edge edge edge edge)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *svcerrors.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|4) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
