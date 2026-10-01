# checker spec for s25 step 2 (see lib/engine.sh)
SCRIPT_NAME=archiver.sh
setup() {
  mkdir -p proj/src "my docs" empty; local i
  for i in 1 2 3; do echo "$i" > "proj/$(word)$i.txt"; done; echo c > proj/src/main.c; echo d > "my docs/two words.txt"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *archiver.sh* ]]; }
pre_arch() { mkdir -p "$H/archives"; }
pre_exist() { mkdir -p "$H/archives"; echo old > "$H/archives/proj.tgz"; }
ARGS=('proj $(pre_arch)' 'proj' '"my docs"' 'empty')
COMPARE="stdout exit files"
