Each line of an access log starts with the client address: `10.0.0.2 - GET /index 200`. Write `ipcount.sh LOG`. It prints one line `IP: N` for each address (N = number of lines that start with it), **the busiest first**; for the same count, by address in alphabetical order (as `sort` orders text).

An associative array counts per address (`declare -A n; n[$ip]=$(( ${n[$ip]:-0} + 1 ))`); then `sort -k2,2nr -k1,1` orders lines like `10.0.0.2 7`.
