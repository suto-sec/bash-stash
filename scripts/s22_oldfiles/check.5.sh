# checker spec for s22 step 5 (see lib/engine.sh)
SCRIPT_NAME=oldfiles.sh
setup() {
  mkdir -p logs/sub "my logs" empty; local i
  for i in 1 2 3 4 5; do echo "$i" > "logs/$(word)$i.log"; touch -d "$(randr 1 40) days ago" "logs/$(word)$i.log" 2>/dev/null; done
  echo old > logs/ancient.log; touch -d "400 days ago" logs/ancient.log
  echo new > logs/today.log; echo mid > logs/sub/mid.log; touch -d "20 days ago" logs/sub/mid.log
  echo s > "my logs/two words.log"; touch -d "90 days ago" "my logs/two words.log"; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *oldfiles.sh* ]]; }
pre_old() { mkdir -p "$H/old"; }
ARGS=('30 logs' '30 logs $(pre_old)' '10 "my logs"' '365 empty' '0 logs' '' 'abc' '30 nothing' '30 notadir.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
