# checker spec for 0427 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in 1 2 3; do randtext 2 > "f$i.txt"; done; tar --sort=name -cf paquete.tar f1.txt f2.txt f3.txt; rm f1.txt f2.txt f3.txt; }
extra_check() { must_use tar; }
