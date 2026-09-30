# checker spec for 1732 (see lib/engine.sh)
SCRIPT_NAME=cronadd.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  crontab -r 2>/dev/null
  if [[ $(rand 4) != 0 ]]; then
    {
      echo "# my jobs"
      echo "$(rand 60) $(rand 24) * * * $HOME/bin/$(word).sh"
      [[ $(rand 2) == 1 ]] && echo "0 3 * * * /usr/bin/updatedb"
      echo ""
      echo "@reboot /usr/bin/$(word)"
    } | crontab -
  fi
  true
}
capture() { crontab -l 2>&1; }
ARGS=('"0 3 * * *" /usr/bin/updatedb' '"*/15 * * * *" "$H/backup.sh >> $H/backup.log 2>&1"' '"30 23 1 12 7" "/bin/echo happy new year"' '"0 */4 * * 1" "$H/ipLog.sh"'
      '"60 * * * *" /bin/true' '"0 24 * * *" /bin/true' '"*/0 * * * *" /bin/true' '"5 4 0 * *" /bin/true' '"0 3 * *" /bin/true' '"0  3 * * *" /bin/true' '"a b c d e" /bin/true' '"1-5 * * * *" /bin/true' '"0 3 * * *"' '')
extra_check() {
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  crontab -r 2>/dev/null; true
}
