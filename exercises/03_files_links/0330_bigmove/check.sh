# checker spec for 0330 (see lib/engine.sh)
SCRIPT_NAME=bigmove.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "src/sub dir" grandes
  local i s
  for i in $(seq 1 9); do
    s=$(pick 100 500 1000 1500 "$(randr 1 3000)")
    bigfile "src/$(pick "$(word)$i.dat" "$(word) $i.iso" "f$i")" "$s"
  done
  bigfile src/exact1000 1000
  bigfile src/.hidden 5000
  bigfile "src/sub dir/huge" 9000
  bigfile target 4000; ln -s ../target src/biglink
  bigfile "grandes/f$(randr 1 9)" 10
  touch fich
}
ARGS=('src 1000 grandes' 'src 0 "$W/out/big files"' 'src 2000 nuevo' 'noexiste 1 x' 'src 10k x' 'src -5 x' 'src 10 fich' 'src 10' '')
