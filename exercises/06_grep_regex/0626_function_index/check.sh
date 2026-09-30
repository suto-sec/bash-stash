# checker spec for 0626 (see lib/engine.sh)
setup() {
  mkdir scripts
  local k n=0 j f
  for k in 1 2 3; do
    f="scripts/$(pick backup deploy 'my tools' util)$k.sh"
    echo '#!/bin/bash' > "$f"
    for j in $(seq "$(randr 4 9)"); do
      n=$((n + 1))
      case $(rand 7) in
        0|1) echo "$(word)$n() {" ;;
        2) echo "  inner$n() {" ;;
        3) echo "# old$n() {" ;;
        4) echo "echo \"fake$n()\"" ;;
        5) echo "function kw$n {" ;;
        *) echo "spaced$n () {" ;;
      esac >> "$f"
      echo "  $(word)" >> "$f"
    done
    echo "_$(word)$k() { :; }" >> "$f"
  done
  echo "notes$n() {" > scripts/notes.txt
}
