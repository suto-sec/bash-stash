# checker spec for s70 step 2 (see lib/engine.sh)
SCRIPT_NAME=inpath.sh
setup() {
  mkdir -p bin1 bin2 bin3 "my bin" empty
  printf '#!/bin/sh\necho one\n' > bin1/tool; chmod 755 bin1/tool
  printf '#!/bin/sh\necho two\n' > bin2/tool; chmod 644 bin2/tool
  printf '#!/bin/sh\necho three\n' > bin3/tool; chmod 755 bin3/tool
  printf '#!/bin/sh\n' > bin1/only1; chmod 755 bin1/only1
  printf '#!/bin/sh\n' > "my bin/tool"; chmod 755 "my bin/tool"
  mkdir -p bin3/dirtool; printf '#!/bin/sh\n' > bin2/plain; chmod 644 bin2/plain
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *inpath.sh* ]]; }
ARGS=('tool bin1:bin2:bin3' 'tool bin3:bin2:bin1' 'only1 bin1:bin2:bin3' 'tool bin2' 'plain bin2' 'dirtool bin3' '"tool" "my bin:bin2"')
COMPARE="stdout exit"
