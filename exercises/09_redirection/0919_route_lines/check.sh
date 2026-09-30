# checker spec for 0919 (see lib/engine.sh)
COMPARE="stdout stderr exit files"
setup() { [[ $(rand 2) == 1 ]] && echo "999 old" > numbers.txt; echo "Old Name" > names.txt; }
input() {
  local i
  for i in $(seq "$(randr 6 16)"); do
    pick "$(randr 0 99999)" "${WORDS[$(rand 20)]^}" "Madrid $(word)" "$(word)" " 12" "12a" "" "-5" "$(randr 1 9) $(word)" "007" "X"
  done
}
