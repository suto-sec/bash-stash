# checker spec for 0703 (see lib/engine.sh)
setup() { mkdir -p fotos/{2024,2025/verano,otras}; local i; for i in $(seq 9); do touch "fotos/$(pick 2024 2025 2025/verano otras)/$(word)$i.$(pick jpg JPG Jpg png jpeg)"; done; }
