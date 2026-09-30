# checker spec for 0531 (see lib/engine.sh)
input() {
  local i w
  for i in 1 2 3 4 5; do
    w=$(word)
    echo "$(pick '' '  ' '¡' '"')${w^} $(pick , '' ' --' .) $(word)$(pick '!!' '?' '' _)$(pick ' ' '  ' '_') $(randr 1 2026)$(pick '' ' ' ' ...') ${w^^}$(pick '' . '  ')"
  done
  echo "file_name.v2.TXT"
}
extra_check() { must_use tr; }
