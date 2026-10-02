# checker spec for s76 step 1 (see lib/engine.sh)
SCRIPT_NAME=worldw.sh
setup() {
  mkdir -p site/css site/priv "my site" empty
  echo a > site/index.html; chmod 666 site/index.html
  echo b > site/css/main.css; chmod 664 site/css/main.css
  echo c > site/css/theme.css; chmod 646 site/css/theme.css
  echo d > site/priv/key; chmod 600 site/priv/key
  echo e > site/run.sh; chmod 777 site/run.sh
  echo f > site/notes.txt; chmod 644 site/notes.txt
  echo g > "my site/two words"; chmod 662 "my site/two words"
  mkdir site/shared; chmod 777 site/shared
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *worldw.sh* ]]; }
SORT_OUTPUT=1
ARGS=('site' '"my site"' 'empty' 'site/css')
COMPARE="stdout exit"
