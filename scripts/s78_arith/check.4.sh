# checker spec for s78 step 4 (see lib/engine.sh)
SCRIPT_NAME=arith.sh
setup() { mkdir -p dir; echo x > file.txt; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *arith.sh* ]]; }
ARGS=('7 + 5' '2 + 3 x 4' '10 - 2 - 3' '100 / 5 / 4' '2 x 3 x 4 x 5' '1 + 1 + 1 + 1 + 1' '20 / 3 x 3 % 4' '' '1 + 2 3' '1 +' '1 + 2 x' 'abc + 1' '1 + 2 + x' '1 + 2 ^ 3' '5 / 0' '8 / 2 / 0' '2 + 3 ^ 4 + 5' '1 + a ^ 2')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == 2 ]]; then
    local bad; bad=$(eval 'set -- '"$CASE"'; r="^-?[0-9]+$"; while (( $# )); do [[ $1 =~ $r ]] || { echo "$1"; break; }; shift; (( $# )) && shift; done'); mentions "$bad"
  fi
  if [[ $REF_CODE == 3 ]]; then
    local bad; bad=$(eval 'set -- '"$CASE"'; r="^-?[0-9]+$"; shift; while (( $# )); do case $1 in +|-|x|/|%) ;; *) echo "$1"; break;; esac; shift 2; done'); mentions "$bad"
  fi
}
