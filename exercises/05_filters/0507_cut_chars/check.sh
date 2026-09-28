# checker spec for 0507 (see lib/engine.sh)
setup() {
  local i; for i in $(seq 6); do echo "$(pick - d l)$(pick rwx rw- r--)$(pick r-x r-- ---)$(pick r-x r-- ---) 1 $(word) $(word) $(randr 10 9999) Jun $(randr 10 28) 12:00 $(word)$i"; done > ls_output.txt
  for i in $(seq 5); do echo "$(word);$(randr 18 30);$(randr 0 10);$(word)"; done > notas.csv
}
