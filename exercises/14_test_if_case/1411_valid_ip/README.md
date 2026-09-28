# 1411 · Validating an IPv4 address

**Topic:** test, if & case · **Difficulty:** ★★★☆☆ · **Commands:** [[ =~ ]], IFS, read -a, -le

The script receives one argument and prints `valid` or `invalid`: a valid IPv4 has exactly 4
decimal numbers from 0 to 255 separated by dots, no leading `+`/`-`, no empty parts.
Exit code: 0 if valid, 1 if invalid. (You will reuse this in the ipLog exercise (1802).)

---
Write your solution in `answer.sh`, then run `check 1411`.  
To experiment with the same test files the checker uses: `play 1411`.
