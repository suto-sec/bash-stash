# 1841 · Files over a size threshold

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** find -size, -printf %s, sort

Write `du_alert.sh DIR LIMIT_KB`. It prints every **regular file** under `DIR` (recursively) whose
size is strictly more than `LIMIT_KB` kibibytes — that means more than `LIMIT_KB * 1024` **exact**
bytes (equivalent to `find DIR -type f -size +$((LIMIT_KB*1024))c`; do **not** use `du`, which rounds
to block size). Sorted by size **descending**, then path (ascending) for ties, as
`<bytes> bytes <path>`. Finally print `Total: N files over LIMIT_KB KB (SUM bytes)` (SUM = sum of
the sizes of those files, in bytes).

Checks, in this order:
- not exactly 2 arguments: usage on stderr, exit **1**.
- `DIR` does not exist: message on stderr (naming `DIR`), exit **2**.
- `DIR` exists but is not a directory: message on stderr (naming `DIR`), exit **3**.
- `LIMIT_KB` is not a positive integer: message on stderr, exit **4**.

---
Write your solution in `answer.sh`, then run `check 1841`.  
To experiment with the same test files the checker uses: `play 1841`.
