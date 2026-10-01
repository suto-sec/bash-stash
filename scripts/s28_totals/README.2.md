Before the grand total print one line `category: sum` for each category that appears, sorted by category name.

An associative array (`declare -A sums`, `sums[$cat]=$(( ${sums[$cat]:-0} + amount ))`) keeps one sum per category; `printf '%s\n' "${!sums[@]}" | sort` lists the names.
