# checker spec for 0734 (see lib/engine.sh)
SCRIPT_NAME=badlinks.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p links/a "links/sub dir/deep"
  local i d
  echo real > links/real1; echo real > "links/sub dir/real 2"; echo out > outside.txt
  for i in $(seq "$(randr 6 10)"); do
    d="links/$(pick . a 'sub dir' 'sub dir/deep')"
    case $(rand 8) in
      0) ln -s "$W/links/real1" "$d/abs ok$i" ;;
      1) ln -s "$W/nothere$i" "$d/abs broken$i" ;;
      2) ln -s "missing $i.txt" "$d/$(word) $i" ;;
      3) ln -s ../../outside.txt "links/a/out$i" ;;
      4) ln -s "real 2" "links/sub dir/ok$i" ;;
      5) ln -s ../a "links/sub dir/dirlink$i" ;;
      6) ln -s "gone$i" "links/a/chain$i.1"; ln -s "chain$i.1" "links/a/chain$i.2" ;;
      7) ln -s ../real1 "links/a/$(word)$i" ;;
    esac
  done
  ln -s "does not exist" "links/sub dir/deep/old link"
  touch afile
}
ARGS=('links' '-d links' '"links/sub dir"' '-d "$W/links"' '' '-d' '-x links' 'links extra' 'noexiste' '-d afile')
