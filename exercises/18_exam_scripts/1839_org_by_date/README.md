# 1839 · Organising files into year-month folders

**Topic:** Exam-style scripts · **Difficulty:** ★★★★☆ · **Commands:** date -r, mkdir -p, mv

Write `org_by_date.sh DIR`. It moves every **regular file directly inside** `DIR` (not recursive,
hidden files ignored) into a subdirectory `DIR/<YYYY-MM>` based on its modification time
(`date -r FILE +%Y-%m`), creating the subdirectory when needed.

Print `<name> -> <YYYY-MM>/<name>` for each move, **in the alphabetical order of the original
names** (as the `*` glob gives them). Then, sorted by bucket name, print `<YYYY-MM>: <count> files`
for every bucket used. Finally print `Total: N files organized`.

Checks, in this order:
- not exactly 1 argument: usage on stderr, exit **1**.
- `DIR` is not a directory: message on stderr (naming `DIR`), exit **2**.

---
Write your solution in `answer.sh`, then run `check 1839`.  
To experiment with the same test files the checker uses: `play 1839`.
