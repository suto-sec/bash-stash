# 0640 · Extracting and normalising MAC addresses

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -Eo, {n}, tr, sort -u

`dispositivos.txt` has lines of free text, some containing a MAC address: six pairs of hexadecimal
digits separated by `:` (case-insensitive). Extract every valid one with a **single** `grep -Eo`
call, convert them all to **lowercase**, and print them **sorted, without duplicates** — so the same
address written in different letter case counts once.

Decoys that must **not** match: groups separated by `-` instead of `:`, fewer than six groups, and a
group containing a non-hexadecimal letter (`G`-`Z`).

---
Write your solution in `answer.sh`, then run `check 0640`.  
To experiment with the same test files the checker uses: `play 0640`.
