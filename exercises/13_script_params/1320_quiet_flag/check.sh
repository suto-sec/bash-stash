# checker spec for 1320 (see lib/engine.sh)
SEEDS=3
SCRIPT_NAME=count.sh
COMPARE="stdout stderr exit"
setup() {
  randtext "$(randr 3 12)" > a.txt
  randtext "$(randr 3 12)" > b.txt
  randtext "$(randr 3 12)" > "c d.txt"
  echo linux > locked.txt; chmod 000 locked.txt
  mkdir sub
}
ARGS=('linux a.txt b.txt "c d.txt"' '-q linux a.txt b.txt' '-q zzz a.txt' 'zzz a.txt "c d.txt"' '' '-q' '-q word' 'word' 'shell a.txt nofile "c d.txt" locked.txt sub' '-q apple locked.txt' 'e "c d.txt"')
