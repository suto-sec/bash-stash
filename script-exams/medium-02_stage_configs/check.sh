# checker spec for the practice exam medium-02 (see lib/engine.sh; graded by objectives with bin/sgrade)
SCRIPT_NAME=stage_configs.sh
OBJECTIVES=(
  "args|Argument checking and error messages|3"
  "select|Choosing the right files|3"
  "dest|The destination directory: creating it and overwriting|2"
  "summary|Counting and the final message|2"
)
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mk() { mkdir -p "$(dirname "$1")"; head -c "$2" /dev/zero | tr '\0' 'x' > "$1"; }
  mk tree/net/hosts.conf "$(randr 1100 4000)"
  mk tree/net/dns/resolv.cfg "$(randr 1100 4000)"
  mk tree/net/small.conf "$(randr 10 1000)"
  mk tree/net/dns/big.txt "$(randr 2000 5000)"
  mk tree/app/main.cfg 2048
  mk tree/app/old/legacy.conf "$(randr 1100 4000)"
  mk tree/app/deep/old/x/hidden.cfg "$(randr 1100 4000)"
  mk tree/app/deep/keep.conf "$(randr 1100 4000)"
  mk tree/docs/notes.CONF "$(randr 1100 4000)"
  mk tree/docs/readme.cfg.bak "$(randr 1100 4000)"
  mkdir -p tree/dirs.conf; ln -s ../net/hosts.conf tree/docs/link.conf
  mk "with space/sub dir/my app.conf" "$(randr 1100 3000)"
  mk "with space/extra.cfg" "$(randr 1100 3000)"
  mk "with space/older.cfg" 900
  mk sizes/a1024.conf 1024
  mk sizes/a1025.cfg 1025
  mk sizes/b0.conf 0
  mk oldonly/old/a.conf 3000
  mk oldonly/old/b.cfg 3000
  mk oldonly/note.txt 3000
  mkdir -p empty/sub
}
pre_s() { mkdir -p "$H/staging"; }
pre_x() { mkdir -p "$H/staging"; echo old > "$H/staging/hosts.conf"; echo keep > "$H/staging/other.txt"; }
ARGS=('tree extra' 'a b c' 'nodir' 'tree/net/hosts.conf'
      'tree $(pre_s)' '"with space" $(pre_s)' 'sizes $(pre_s)' 'oldonly $(pre_s)'
      'tree' 'tree $(pre_x)'
      'empty' '$(pre_s)' 'tree/net $(pre_s)')
CASE_OBJ=(args args args args  select select select select  dest dest  summary summary summary)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *stage_configs.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
