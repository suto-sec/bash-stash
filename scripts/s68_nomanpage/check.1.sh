# checker spec for s68 step 1 (see lib/engine.sh)
SCRIPT_NAME=nomanpage.sh
setup() {
  mkdir -p bin man/man1 empty "my bin" noman
  local c
  for c in ls cat grep sort cut tr; do echo "#!/bin/sh" > "bin/$c"; touch "man/man1/$c.1.gz"; done
  for c in mytool helper-x backup2 python3.11; do echo "#!/bin/sh" > "bin/$c"; done
  touch "man/man1/helper.1.gz" "man/man1/python3.11.1.gz"
  echo x > "my bin/two words"; echo x > "my bin/ls"; touch "man/man1/ls.1.gz"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *nomanpage.sh* ]]; }
ARGS=('bin man/man1' '"my bin" man/man1' 'empty man/man1' 'bin noman')
COMPARE="stdout exit"
