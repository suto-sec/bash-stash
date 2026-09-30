# checker spec for 0628 (see lib/engine.sh)
SCRIPT_NAME=wordle.sh
SEEDS=2
COMPARE="stdout exit errmsg"
POOL=(crane slate stare spare share shore shire spire spine brine bring brand grand gland plant plane crate
      grate trace react cater later alter alert apple grape lemon mango melon peach alpha bravo delta hotel
      oscar romeo tango linux shell cache sugar tiger water paper eager ocean)
setup() {
  local i
  for i in $(seq 45); do pick "${POOL[@]}"; done > dict.txt
  printf '%s\n' Crane APPLE cranes cran "can't" "sh_ll" "e-mail" "trace " "12345" >> dict.txt
  for i in $(seq 30); do pick "${POOL[@]}" Slate; done > "my words.txt"
}
ARGS=('dict.txt _____' 'dict.txt __a__' 'dict.txt s____ ae' '"my words.txt" ___e_ rt' 'dict.txt c_a__ xyz'
      'dict.txt zz___' 'dict.txt' 'a b c d' 'nofile _____' '. _____' 'dict.txt abc' 'dict.txt ab_D_'
      'dict.txt _____ A1' 'dict.txt _____ ""')
extra_check() {
  [[ $REF_CODE == [23] ]] && mentions "$(eval "set -- $CASE"; [[ $REF_CODE == 2 ]] && echo "$1" || echo "$2")"
  true
}
