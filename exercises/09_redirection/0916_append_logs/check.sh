# checker spec for 0916 (see lib/engine.sh)
COMPARE="stdout stderr exit files"
setup() {
  cat > job.sh << 'EOF'
#!/bin/bash
echo "[$1] start"
case $1 in *a*) echo "[$1] warning: name contains an a" >&2 ;; esac
case $1 in *e*) echo "[$1] error: name contains an e" >&2 ;; esac
echo "[$1] done"
EOF
  chmod +x job.sh
  local i
  for i in $(seq "$(randr 2 5)"); do word; done > tareas.txt
  [[ $(rand 2) == 1 ]] && echo "[old] start" > run.log
  [[ $(rand 2) == 1 ]] && printf '[old] error 1\n[old] error 2\n' > err.log
  true
}
