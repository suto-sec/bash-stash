# checker spec for 1717 (see lib/engine.sh)
SEEDS=1
COMPARE="exit"
setup() { printf '@reboot echo lab-%s >> /tmp/reboot.log\n' "$(word)" | crontab -; }
capture() { crontab -l 2>&1 | grep -c '^@reboot echo lab-'; }
extra_check() {
  local line m h dom mon dow cmd hours=()
  line=$(crontab -l 2>/dev/null | grep ipLog.sh | head -1)
  [[ -n $line ]] || { fail "no crontab line running ipLog.sh"; return; }
  read -r m h dom mon dow cmd <<< "$line"
  [[ $m == 0 ]] || fail "minute field should be 0 (got '$m')"
  [[ $dom == '*' && $mon == '*' && $dow == '*' ]] || fail "day/month/weekday fields should be *"
  case $h in
    '*/4'|'0-23/4'|'0,4,8,12,16,20') ;;
    *) fail "hour field '$h' does not mean every 4 hours starting at 0" ;;
  esac
  [[ $cmd == "$H/ipLog.sh"* || $cmd == *" $H/ipLog.sh"* ]] || fail "command must use the absolute path $H/ipLog.sh"
  [[ $cmd == *">> $H/ipLog.log"* || $cmd == *">>$H/ipLog.log"* ]] || fail "output must be appended (>>) to $H/ipLog.log"
  [[ $cmd == *"2>&1"* ]] || fail "stderr must also go to the log (2>&1)"
  crontab -r 2>/dev/null
}
