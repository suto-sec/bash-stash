# 0116 · Printing arbitrary text safely

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★☆☆ · **Commands:** printf '%s\n', ${#v}, ${v//x/y}

The file `raw.txt` contains **one line** of text that you must print **exactly** as it is. Be careful:
the text can start with `-n` or `-e`, and can contain backslashes (`\t`, `\c`, `\\`) and `%` signs,
which `echo` (options!) and `printf "$TEXT"` (format!) would interpret.

Read the line into a variable (`TEXT=$(cat raw.txt)`) and print:

```
<the text, exactly>
Length: <number of characters of the text>
Backslashes: <number of \ characters in the text>
```

Hint: the safe way is `printf '%s\n' "$TEXT"`. To count characters, remember `${#VAR}` and that
`${VAR//pattern/}` deletes every match of a pattern.

---
Write your solution in `answer.sh`, then run `check 0116`.  
To experiment with the same test files the checker uses: `play 0116`.
