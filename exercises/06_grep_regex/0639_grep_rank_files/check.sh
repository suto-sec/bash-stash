# checker spec for 0639 (see lib/engine.sh)
setup() {
  local names=(alpha beta gamma delta epsilon zeta) n i cnt fill f j
  mkdir -p logs
  n=$(randr 4 6)
  for i in $(seq "$n"); do
    f="logs/${names[$((i - 1))]}.log"
    cnt=$(pick 0 0 1 2 3)
    fill=$(randr 1 4)
    : > "$f"
    for j in $(seq "$cnt"); do echo "$(pick Timeout TIMEOUT timeout) $(word)" >> "$f"; done
    for j in $(seq "$fill"); do echo "$(word) $(word)" >> "$f"; done
  done
}
