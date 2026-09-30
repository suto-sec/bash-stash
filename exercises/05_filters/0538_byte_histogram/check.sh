# checker spec for 0538 (see lib/engine.sh)
ARGS=('data.txt' '"my file.bin"' 'empty.bin')
setup() {
  local i
  { randtext 3; head -c "$(randr 40 90)" /dev/zero | tr '\0' 'x'; echo; randtext 2; } > data.txt
  for ((i = 0; i < 30; i++)); do printf "\\$(printf '%03o' "$(pick 0 9 10 65 66 66 200 255)")"; done > "my file.bin"
  head -c "$(randr 20 60)" /dev/zero >> "my file.bin"
  : > empty.bin
}
extra_check() { must_use od; }
