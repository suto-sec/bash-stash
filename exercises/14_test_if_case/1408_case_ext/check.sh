# checker spec for 1408 (see lib/engine.sh)
SEEDS=1
ARGS=('foto.jpg FOTO.PNG a.jpeg x.gif' 'tesis.pdf notas.txt c.odt d.docx' 'b.tar c.tgz d.tar.gz e.zip' 'run.sh sh noext a.b.c .bashrc' 'Foto.Jpg')
extra_check() { must_use case; }
