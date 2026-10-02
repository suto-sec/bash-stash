# checker spec for s80 step 1 (see lib/engine.sh)
SCRIPT_NAME=shebang.sh
setup() {
  mkdir -p tools/sub "my tools" empty
  printf '#!/bin/bash\necho ok\n' > tools/good.sh;      chmod 755 tools/good.sh
  printf 'echo no shebang\n' > tools/noshe.sh;          chmod 755 tools/noshe.sh
  printf '#!/bin/sh\necho not exec\n' > tools/noexec.sh; chmod 644 tools/noexec.sh
  printf 'echo both\n' > tools/both.sh;                 chmod 644 tools/both.sh
  : > tools/empty.sh;                                    chmod 755 tools/empty.sh
  printf '# a comment first\n#!/bin/bash\n' > tools/late.sh; chmod 755 tools/late.sh
  printf '#!/usr/bin/env bash\necho two\n' > "tools/two words.sh"; chmod 644 "tools/two words.sh"
  printf 'echo deep\n' > tools/sub/deep.sh;             chmod 700 tools/sub/deep.sh
  printf 'echo hid\n' > tools/.hid.sh;                  chmod 755 tools/.hid.sh
  printf 'echo text\n' > tools/readme.txt;              chmod 644 tools/readme.txt
  mkdir -p tools/dir.sh
  printf '#!/bin/bash\n' > "my tools/ok.sh"; chmod 755 "my tools/ok.sh"
  printf 'x\n' > "my tools/bad.sh"; chmod 644 "my tools/bad.sh"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *shebang.sh* ]]; }
SORT_OUTPUT=1
ARGS=('tools' '"my tools"' 'empty')
COMPARE="stdout exit"
