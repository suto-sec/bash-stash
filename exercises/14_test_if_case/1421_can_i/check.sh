# checker spec for 1421 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=cani.sh
COMPARE="stdout stderr exit"
setup() {
  echo r > r.txt; chmod 444 r.txt
  echo w > w.txt; chmod 200 w.txt
  echo x > x.sh; chmod 755 x.sh
  echo n > nox.sh; chmod 644 nox.sh
  mkdir "open dir" "locked dir" "ro dir" wx
  echo in > "locked dir/in.txt"; chmod 000 "locked dir"
  chmod 555 "ro dir"; chmod 300 wx
}
ARGS=('read r.txt' 'write r.txt' 'read w.txt' 'write w.txt' 'run x.sh' 'run nox.sh' 'run "open dir"' 'read "open dir"' 'enter "open dir"' 'list "open dir"' 'enter "locked dir"' 'list wx' 'enter wx' 'read "locked dir/in.txt"' 'create "open dir/new file"' 'create "ro dir/new"' 'create "open dir"' 'create nodir/x' 'create newfile' 'create "wx/new"' 'delete r.txt' '' 'read' 'read a b')
