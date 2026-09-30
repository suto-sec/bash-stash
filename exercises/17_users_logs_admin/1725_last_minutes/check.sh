# checker spec for 1725 (see lib/engine.sh)
SCRIPT_NAME=sesiones.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local i us=("$(word)" "$(word)" "$(word)") end
  for i in $(seq "$(randr 4 12)"); do
    case $(rand 5) in
      0) end="still logged in" ;;
      1) end="gone - no logout" ;;
      2) end="- $(randr 10 23):$(randr 10 59)  ($(randr 1 3)+0$(rand 10):$(randr 10 59))" ;;
      *) end="- $(randr 10 23):$(randr 10 59)  (0$(rand 10):$(pick 00 05 $(randr 10 59)))" ;;
    esac
    printf '%-8s %-12s %-16s %s\n' "$(pick "${us[@]}")" "pts/$i" "$(pick "$(ip_rand)" ':0' '')" "Mon Jun 15 1$(rand 10):0$(rand 10) $end"
    [[ $(rand 5) == 0 ]] && printf '%-8s %-12s %-16s %s\n' reboot "system boot" 6.1.0-lab "Mon Jun 15 08:00   still running"
  done > "last out.txt"
  printf '\nwtmp begins Fri Jun 12 07:44:00 2026\n' >> "last out.txt"
}
ARGS=('' '"last out.txt"' 'noexiste' 'a b')
