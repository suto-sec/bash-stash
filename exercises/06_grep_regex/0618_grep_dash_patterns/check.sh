# checker spec for 0618 (see lib/engine.sh)
setup() {
  local i
  for i in $(seq 18); do
    pick "rm -rf $(word)" "rm -r -f $(word)" "ls -l $(word)" "cp --force $(word) $(word)" "git push --dry-run" \
         "make -n $(word)" "echo $(word)" "tar -xvf $(word).tar" "cat $(word)" "sort -rn $(word)" "rsync --dry-run -a x y" "rm -fr $(word)"
  done > cmds.txt
}
extra_check() { must_use grep; }
