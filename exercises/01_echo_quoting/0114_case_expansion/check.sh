# checker spec for 0114 (see lib/engine.sh)
SEEDS=4
mixcase() { local a=${1:0:2} b=${1:2:2} c=${1:4}; echo "${a,,}${b^^}${c,,}"; }
setup() {
  local f l
  f=$(word); l=$(word)$(word)
  f=$(pick "$f" "${f^^}" "${f^}" "$(mixcase "$f")"); l=$(pick "${l^^}" "${l^}" "$(mixcase "$l")" "$(mixcase "${l^^}")")
  echo "$f $l" > person.txt
}
extra_check() { must_not_use tr sed; }
