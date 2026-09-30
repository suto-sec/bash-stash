# checker spec for 0412 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p proyecto/src proyecto/tmp
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do randtext 2 > "proyecto/src/$(word)$i.c"; done
  for i in $(seq "$(randr 1 3)"); do randtext 2 > "proyecto/tmp/$(word)$i.log"; done
  randtext 2 > proyecto/README
}
extra_check() {
  [[ -f $W/codigo.tgz ]] || { fail "codigo.tgz was not created"; return; }
  gzip -t "$W/codigo.tgz" 2>/dev/null || { fail "codigo.tgz is not gzip-compressed (use -z)"; return; }
  local expected got
  expected=$(cd "$W" && find proyecto -not -path 'proyecto/tmp*' | sed 's#/$##' | sort)
  got=$(tar tzf "$W/codigo.tgz" | sed 's#/$##' | sort)
  diff <(echo "$expected") <(echo "$got") >/dev/null || fail "the archive must contain everything under proyecto except proyecto/tmp (check with tar tzf)"
}
