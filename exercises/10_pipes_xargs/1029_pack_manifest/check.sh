# checker spec for 1029 (see lib/engine.sh)
SCRIPT_NAME=pack.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  local i f
  mkdir -p "src/my lib" conf "empty dir"
  for i in $(seq "$(randr 5 9)"); do
    f="$(pick src 'src/my lib' conf .)/$(word)$(pick '' ' ')$i.$(pick c txt conf)"; f=${f#./}
    echo "$(word) $i" > "$f"
    case $(rand 5) in
      0) ;;
      1) echo "#$f" ;;
      *) echo "$f" ;;
    esac
  done > list.tmp
  { echo "# files to back up"; cat list.tmp; echo; echo "conf/gone$(word).conf"; echo "empty dir"; echo "src/my lib"; echo "conf/always.conf"; } > manifest.txt
  echo "always" > conf/always.conf
  rm list.tmp
  cp manifest.txt "my list.txt"; echo "not/here.txt" >> "my list.txt"
  printf '# nothing\n\nnope/a.txt\nsrc\n' > empty.txt
  [[ $(rand 2) == 1 ]] && tar -czf out.tar.gz empty.txt
  true
}
ARGS=('manifest.txt out.tar.gz' '"my list.txt" "backup 1.tar.gz"' 'manifest.txt "$W/conf/x.tar.gz"' 'empty.txt e.tar.gz' 'manifest.txt out.zip' 'nope.txt out.tar.gz' 'src out.tar.gz' 'manifest.txt' 'a b c')
