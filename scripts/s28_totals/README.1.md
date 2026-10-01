Write `totals.sh FILE`. Every line of `FILE` is `category:amount` with an integer amount (blank lines must be ignored). Print `TOTAL: S`, the sum of all the amounts (`TOTAL: 0` for an empty file).

`while IFS=: read -r cat amount; do ...; done < file`.
