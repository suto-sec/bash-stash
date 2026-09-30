# checker spec for 0640 (see lib/engine.sh)
setup() {
  local mac1 mac2 i p
  mac1=""
  for i in $(seq 6); do p=$(printf '%02X' "$(rand 256)"); mac1+="${mac1:+:}$p"; done
  mac2=""
  for i in $(seq 6); do p=$(printf '%02X' "$(rand 256)"); mac2+="${mac2:+:}$p"; done
  : > dispositivos.txt
  echo "host1 mac $mac1 activo" >> dispositivos.txt
  echo "host2 mac $(echo "$mac1" | tr 'A-F' 'a-f') duplicado" >> dispositivos.txt
  echo "host3 mac $mac2 nuevo" >> dispositivos.txt
  echo "host4 mac $(echo "$mac1" | tr ':' '-') guion" >> dispositivos.txt
  echo "host5 mac ${mac1%:*} corto" >> dispositivos.txt
  echo "host6 mac ${mac1/${mac1:0:2}/GG} hexmalo" >> dispositivos.txt
}
