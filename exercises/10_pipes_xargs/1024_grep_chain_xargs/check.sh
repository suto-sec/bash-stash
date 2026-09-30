# checker spec for 1024 (see lib/engine.sh)
setup() {
  mkdir -p "notes/week 1" notes/old
  local w1 w2 i f
  w1=$(pick linux kernel shell apple mango); w2=$(pick socket buffer cache peach lemon)
  printf '%s\n' "$w1" "$w2" > words.txt
  for i in $(seq "$(randr 5 10)"); do
    f="notes/$(pick . 'week 1' old)/$(word)$(pick '' ' ')$i.txt"
    { randtext "$(randr 1 4)"; echo "$(pick "$w1" "$w2" "$w1 $w2" "${w1^^}" x) $(word)"; randtext 2; echo "$(pick "$w2" '' "$w1")"; } > "$f"
  done
}
