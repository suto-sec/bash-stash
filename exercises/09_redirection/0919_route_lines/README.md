# 0919 · Routing the lines of stdin to several files

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** while read, exec 3> file, >&3, >&2

The script reads lines from its **standard input** until the end and routes each one:

- lines made only of digits (at least one) → file `numbers.txt`
- lines whose first character is an uppercase letter `A-Z` → file `names.txt`
- empty lines → ignored
- any other line → **stderr**, as `skipped: <line>`

Both files must be **overwritten** by each execution (they may already exist) and are created even
if nothing goes into them. Lines are written unchanged, in input order. Finally print on stdout
`<a> numbers, <b> names, <c> skipped`.

Tip: open both files once, before the loop (`exec 3> numbers.txt 4> names.txt`), and write with `>&3`.

---
Write your solution in `answer.sh`, then run `check 0919`.  
To experiment with the same test files the checker uses: `play 0919`.
