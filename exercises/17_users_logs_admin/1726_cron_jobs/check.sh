# checker spec for 1726 (see lib/engine.sh)
SCRIPT_NAME=cronjobs.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i f
  for f in cron.txt "my cron"; do
    {
      echo "# m h dom mon dow command"
      echo "MAILTO=$(word)"
      for i in $(seq "$(randr 2 6)"); do
        case $(rand 5) in
          0) echo "$(pick @reboot @daily @hourly @weekly) /usr/bin/$(word).sh  --$(word)" ;;
          1) printf '%s\t%s\t*\t*\t%s\t%s\n' "$(rand 60)" "*/$(randr 2 6)" "$(pick 1-5 0 '*')" "$HOME/bin/$(word).sh >> $HOME/log 2>&1" ;;
          2) echo "  # $(words 3)" ;;
          3) echo "" ;;
          4) echo "$(pick 0 15 30)  $(rand 24) $(randr 1 28) $(pick '*' 6 12) *   /bin/echo $(words 2)" ;;
        esac
      done
      echo "*/5 * * * * /usr/bin/date >> /tmp/date.log"
    } > "$f"
  done
  if [[ $(rand 3) == 0 ]]; then crontab -r 2>/dev/null; else crontab "my cron"; fi
  true
}
ARGS=('' 'cron.txt' '"my cron"' '"$W/cron.txt"' 'noexiste' '.' 'a b')
extra_check() { crontab -r 2>/dev/null; true; }
