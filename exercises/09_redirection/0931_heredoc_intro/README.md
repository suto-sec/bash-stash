# 0931 · Quick refresher: << (heredoc)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★☆☆☆☆ · **Commands:** << EOF

A here document gives a command several lines of text typed right in the script. It starts with `<< WORD` and ends at a line that contains only `WORD`.

Create the file `saludo.txt` with exactly these two lines:

```
hola
adios
```

Use a here document with `cat`: `cat > saludo.txt << EOF`, then the two lines, then a line with only `EOF`. Nothing is printed on the screen.

Hint:

```
cat > file << EOF
first line
second line
EOF
```

---
Write your solution in `answer.sh`, then run `check 0931`.  
To experiment with the same test files the checker uses: `play 0931`.
