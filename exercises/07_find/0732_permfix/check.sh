# checker spec for 0732 (see lib/engine.sh)
SCRIPT_NAME=permfix.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "tree/my sub/deep" tree/bin tree/doc
  local i f
  for i in $(seq "$(randr 7 12)"); do
    f="tree/$(pick . 'my sub' 'my sub/deep' bin doc)/$(word)$(pick '' ' ')$i$(pick .sh .txt .sh .md '')"
    echo "$i" > "$f"
    chmod "$(pick 600 640 644 664 666 700 744 755 775 777 750)" "$f"
  done
  for f in tree "tree/my sub" "tree/my sub/deep" tree/bin tree/doc; do chmod "$(pick 700 750 755 775 777 711 755)" "$f"; done
  mkdir -p tree/doc/tools.sh
  ln -s ../bin tree/doc/binlink
  touch file.txt
}
ARGS=('tree' '"tree/my sub"' '"$W/tree"' '' 'tree x' 'noexiste' 'file.txt')
