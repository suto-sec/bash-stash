# checker spec for 0724 (see lib/engine.sh)
setup() {
  mkdir -p music/rock music/jazz "music/pop hits/old"
  local i
  for i in $(seq "$(randr 8 14)"); do
    touch "music/$(pick . rock jazz 'pop hits' 'pop hits/old')/$(pick intro outro 'track one' theme ballad "$(word)").$(pick mp3 ogg mp3)"
  done
  rm -rf "music/jazz/intro.mp3"; mkdir -p "music/jazz/intro.mp3"
}
