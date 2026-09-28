# 0903 · Discarding output

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** /dev/null, 2>/dev/null, &>/dev/null

The provided script `ruidoso.sh` (in the current directory) prints things to stdout **and** stderr.
Run it three times:

1. discarding only its **errors** (you see its normal output)
2. discarding only its **normal output** (you see its errors: they go to your stderr, the checker
   compares both streams)
3. discarding **everything**, and then print `exit code: N` with its exit code

---
Write your solution in `answer.sh`, then run `check 0903`.  
To experiment with the same test files the checker uses: `play 0903`.
