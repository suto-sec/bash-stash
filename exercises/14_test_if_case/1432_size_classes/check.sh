# checker spec for 1432 (see lib/engine.sh)
SCRIPT_NAME=size_classes.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local d="data files" i f
  mkdir "$d"
  for ((i = 1; i <= $(randr 4 8); i++)); do
    f="$d/$(pick "$(word)$i" "my $(word)$i").$(pick dat txt bin)"
    bigfile "$f" "$(pick "$(randr 1 99)" "$(randr 100 2000)" "$(randr 2001 5000)")"
  done
  bigfile "$d/edge low" 100; bigfile "$d/edge high" 2000
  : > "$d/empty$(rand 9).txt"
  bigfile "$d/secret.dat" "$(randr 1 3000)"; chmod 000 "$d/secret.dat"
  mkdir "$d/sub dir"; bigfile "$d/.hidden" 5000
  echo x > file.txt
}
ARGS=('"data files" 100 2000' '"data files" 0 0' '"data files" 1000 1000' '"$W/data files" 50 4000' 'file.txt 1 2' 'nodir 1 2' '"data files" x 10' '"data files" 10 -5' '"data files" 2000 100' '' '"data files" 1' 'a b c d')
extra_check() {
  local tok
  if [[ $REF_CODE == [23] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
