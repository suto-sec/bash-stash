# checker spec for 1628 (see lib/engine.sh)
SCRIPT_NAME=informe_scripts.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "prog/sub uno" "prog/sub dos"
  local f1 f2 f3 f4
  f1="prog/a $(word)1.sh"; mkfl "$f1" '#!/bin/bash' 'echo hi'; chmod +x "$f1"
  f2="prog/sub uno/b $(word)2.sh"; mkfl "$f2" 'echo hi'
  f3="prog/sub dos/c $(word)3.sh"; mkfl "$f3" '#!/bin/bash' 'echo hi'; chmod +x "$f3"
  f4="prog/d $(word)4.sh"; mkfl "$f4" '#!/bin/bash' 'echo hi'
  touch "prog/nota.txt"
  touch nota.txt
}
ARGS=('prog' '' 'prog extra' 'nota.txt' 'noexiste')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  must_use die analizar read
}
