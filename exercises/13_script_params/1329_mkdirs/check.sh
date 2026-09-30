# checker spec for 1329 (see lib/engine.sh)
SCRIPT_NAME=mkdirs.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i
  mkdir "my base" proj
  for i in 1 2 3 4 5 6; do
    case $(rand 4) in
      0) mkdir "my base/dir0$i" ;;
      1) echo x > "my base/dir0$i" ;;
    esac
  done
  mkdir "proj/part0$(randr 1 9)"; echo y > "proj/part1$(rand 3)"
  echo z > file.txt
}
ARGS=('"my base" 6' '"my base" 3 run_' 'proj 12 part' '"my base" 0' '"my base" 100' '"my base" 07' '"my base" x' 'nobase 3' 'file.txt 3' '"my base" 3 bad-prefix' '"my base" 2 ""' '' 'a' 'a 1 b c' '"$W/proj" 2 part')
extra_check() {
  local tok
  if [[ $REF_CODE == [2345] ]]; then
    tok=$(sed -n "s/^[^']*'\(.*\)'.*$/\1/p" <<< "$REF_ERR" | head -n 1)
    [[ -n $tok ]] && mentions "$tok"
  fi
  true
}
