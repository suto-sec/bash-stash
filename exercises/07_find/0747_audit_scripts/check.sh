# checker spec for 0747 (see lib/engine.sh)
SCRIPT_NAME=audit_scripts.sh
SEEDS=2
setup() {
  mkdir -p proj/src proj/vendor/pkg proj/vendor_old proj/tools
  local i f
  for i in $(seq 10); do
    f="proj/$(pick . src vendor vendor/pkg vendor_old tools)/$(word)$i$(pick .sh .sh .txt .shx)"
    touch "$f"
    chmod "$(pick 755 644 700 600 754)" "$f"
  done
  echo ok > proj/tools/keepme.sh;        chmod 755 proj/tools/keepme.sh
  echo ok > proj/vendor/pkg/hidden.sh;   chmod 755 proj/vendor/pkg/hidden.sh
  echo ok > proj/vendor_old/notvendor.sh; chmod 755 proj/vendor_old/notvendor.sh
}
ARGS=('' 'proj' '"$W/proj"')
