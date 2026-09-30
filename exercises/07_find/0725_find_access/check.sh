# checker spec for 0725 (see lib/engine.sh)
setup() {
  mkdir -p share/pub share/priv "share/team docs" share/locked share/noread
  local i f d
  for i in $(seq 12); do
    d=$(pick pub priv 'team docs' locked noread pub)
    f="share/$d/$(word)$(pick '' ' ')$i$(pick .txt .dat .txt)"
    echo "$(word)" > "$f"; chmod "$(pick 644 600 000 200 444 640 222 664)" "$f"
  done
  mkdir -p share/pub/inner "share/team docs/closed"
  chmod "$(pick 700 000)" share/locked
  chmod "$(pick 300 755)" share/noread
  chmod "$(pick 000 755)" "share/team docs/closed"
}
