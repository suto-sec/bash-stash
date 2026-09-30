# checker spec for 0332 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  randtext "$(randr 1 4)" > a.txt; chmod "$(pick 644 600 640 755)" a.txt
  randtext "$(randr 1 4)" > b.txt; chmod "$(pick 644 600 640 755)" b.txt
}
