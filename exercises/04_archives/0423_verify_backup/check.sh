# checker spec for 0423 (see lib/engine.sh)
SCRIPT_NAME=verify_backup.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "actual/docs" actual/src
  local i f
  for i in 1 2 3 4 5; do
    f=$(pick "docs/$(word)$i.txt" "src/$(word)$i.c" "$(word)$i.md" "docs/$(word) $i.txt")
    randtext "$(randr 1 4)" > "actual/$f"
  done
  cp -r actual respaldo_ok
  tar -C respaldo_ok -czf ok.tar.gz .

  cp -r actual respaldo_mod
  local files first last
  files=$(cd actual && find . -type f | sed 's#^\./##' | sort)
  first=$(head -n1 <<< "$files")
  last=$(tail -n1 <<< "$files")
  randtext 3 > "respaldo_mod/$first"
  rm -f "respaldo_mod/$last"
  randtext 1 > "respaldo_mod/extra_$(word).dat"
  tar -C respaldo_mod -czf mod.tar.gz .

  echo basura > roto.tar.gz
  touch fich
}
ARGS=(
  'actual ok.tar.gz'
  'actual mod.tar.gz'
  '"$W/actual" "$W/ok.tar.gz"'
  'actual'
  ''
  'actual noexiste.tar.gz'
  'actual roto.tar.gz'
  'fich ok.tar.gz'
)
extra_check() {
  case $REF_CODE in
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
