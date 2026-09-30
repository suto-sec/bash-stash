# 0914 · Reading a file line by line, exactly

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★☆☆ · **Commands:** while IFS= read -r, done < in > out, printf, ${#var}

Create `salida.txt` from `entrada.txt`: for **every** line of `entrada.txt` (also empty ones), write

```
<line number>|<the line, exactly as it is>|<its length in characters>
```

The lines may have leading/trailing spaces and tabs, backslashes, `*`, or be `-n`; they must be
copied **unchanged**. The last line of `entrada.txt` has **no** final newline and must be processed too.

Redirect the whole loop (`while ...; do ...; done < entrada.txt > salida.txt`), and finally print
on the screen `<N> lines processed`.

---
Write your solution in `answer.sh`, then run `check 0914`.  
To experiment with the same test files the checker uses: `play 0914`.
