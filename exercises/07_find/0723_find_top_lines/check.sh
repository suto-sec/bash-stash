# checker spec for 0723 (see lib/engine.sh)
setup() {
  mkdir -p src/core "src/net io"
  local i
  for i in $(seq "$(randr 3 8)"); do
    randtext "$(pick 5 12 12 20 $(randr 1 40))" > "src/$(pick . core 'net io')/$(word)$(pick '' ' ')$i$(pick .c .h .c .cpp .txt)"
  done
  randtext 60 > src/core/notes.txt
  randtext "$(randr 1 30)" > "src/main.c"
}
