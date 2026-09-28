# checker spec for 0401 (see lib/engine.sh)
setup() { mkdir -p Datos/{Inversiones,Stocks} Textos/Cartas; local f; for f in Datos/Stocks/$(word).txt Datos/Inversiones/$(word).txt Textos/Cartas/$(word); do randtext 3 > "$f"; done; }
COMPARE="stdout exit"
extra_check() {
  [[ -f $W/archivo.tgz ]] || { fail "archivo.tgz was not created"; return; }
  gzip -t "$W/archivo.tgz" 2>/dev/null || { fail "archivo.tgz is not gzip-compressed (use z)"; return; }
  diff <(cd "$W" && find Datos Textos | sort) <(tar tzf "$W/archivo.tgz" | sed 's#/$##' | sort) >/dev/null || fail "the archive content is not Datos/ + Textos/ (check with tar tzf)"
}
