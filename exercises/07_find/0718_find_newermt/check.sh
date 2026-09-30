# checker spec for 0718 (see lib/engine.sh)
setup() {
  mkdir -p fotos/viaje "fotos/casa nueva"
  local i n f
  n=$(randr 7 11)
  for ((i = 1; i <= n; i++)); do
    f="fotos/$(pick . viaje 'casa nueva')/$(word)$(pick '' ' ')$i.$(pick jpg png)"
    touch -d "$(pick 2023-11-20 2023-12-30 2024-01-03 2024-03-15 2024-07-15 2024-12-29 2025-01-03 2025-04-10) 10:$(printf %02d "$i")" "$f"
  done
}
