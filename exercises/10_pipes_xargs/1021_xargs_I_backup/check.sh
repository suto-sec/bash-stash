# checker spec for 1021 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() {
  mkdir -p "my docs" src
  local i f
  for i in $(seq "$(randr 4 8)"); do
    f="$(pick . 'my docs' src)/$(word)$(pick '' ' ' ' old ')$i.$(pick txt conf md)"
    f=${f#./}
    echo "$(word) $i" > "$f"
    [[ $(rand 3) != 0 ]] && echo "$f"
  done > lista.txt
  echo "first entry" > "always here.txt"; echo "always here.txt" >> lista.txt
}
extra_check() { must_use xargs; }
