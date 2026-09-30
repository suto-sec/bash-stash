# checker spec for 1212 (see lib/engine.sh)
SEEDS=1
setup() {
cat > cleanup.sh <<'SCRIPT'
#!/bin/bash
trap 'echo done > "$1"; exit 0' TERM
while true; do sleep 0.1; done
SCRIPT
chmod +x cleanup.sh
}
