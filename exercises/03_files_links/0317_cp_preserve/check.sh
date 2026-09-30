# checker spec for 0317 (see lib/engine.sh)
COMPARE="stdout exit files mtime"
setup() {
  local i n w
  n=$(randr 3 5)
  for ((i = 1; i <= n; i++)); do
    w="$(word)$i"; (( i == 2 )) && w="my $w"
    randtext 3 > "$w.conf"; chmod "$(pick 600 640 644 666 664)" "$w.conf"
    touch -d "20$(randr 15 24)-0$(randr 1 9)-1$(randr 0 9) 1$(randr 0 9):$(randr 10 59)" "$w.conf"
    if (( i == 1 || $(rand 2) == 1 )); then
      randtext 1 > "$w.conf.bak"; touch -d "2014-02-0$(randr 1 9) 10:00" "$w.conf.bak"
      (( $(rand 2) )) && { echo old > "$w.conf.bak.old"; touch -d "2013-01-01 08:00" "$w.conf.bak.old"; }
    fi
  done
  randtext 2 > "$(word).txt"; touch -d "2019-05-05 05:05" ./*.txt
  randtext 2 > "$(word).conf.orig"; touch -d "2018-01-01 01:01" ./*.conf.orig
}
