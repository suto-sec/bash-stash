# checker spec for 0537 (see lib/engine.sh)
COMPARE="stdout stderr exit"
ARGS=('base.txt same.txt' 'base.txt ws.txt' 'base.txt "the diff.txt"' 'short.txt base.txt' 'base.txt short.txt' '"the diff.txt" ws.txt')
setup() {
  local i n; n=$(randr 5 10)
  for ((i = 0; i < n; i++)); do words "$(randr 2 6)"; done > base.txt
  cp base.txt same.txt
  sed "$(randr 1 "$n")s/ /  /; $(randr 1 "$n")s/\$/ \t/" base.txt > ws.txt
  sed "$(randr 1 "$n")s/[a-z]/Z/" base.txt > "the diff.txt"
  head -n "$(randr 1 $(( n - 1 )))" base.txt > short.txt
}
