# 0118 · caja.sh: text in a box

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★★☆ · **Commands:** printf, ${#v}, tr, quoting, $#, exit codes

Write `caja.sh`:

```
caja.sh TEXT [CHAR]
```

It prints `TEXT` inside a box drawn with the character `CHAR` (default `#`), then a summary line.
Example: `caja.sh "hola  mundo" '*'` prints

```
***************
* hola  mundo *
***************
Box: 3 lines, 15 columns
```

- The border lines are `CHAR` repeated `L + 4` times, where `L` is the number of characters of `TEXT`.
- The middle line is `CHAR`, a space, `TEXT` **exactly** (spaces, `*`, `$`... preserved), a space, `CHAR`.
- The summary line is `Box: 3 lines, W columns` with W = L + 4.

Errors (message on **stderr**, nothing on stdout), checked in this order:

- no arguments or more than 2: error message with the **usage**, exit **1**
- `CHAR` given but it is not exactly one character: exit **2**
- `TEXT` is empty or longer than 40 characters: exit **3**

Careful: the checker runs your script in a directory full of files, and `CHAR` may be `*`.
Texts and characters are plain ASCII.

---
Write your solution in `answer.sh`, then run `check 0118`.  
To experiment with the same test files the checker uses: `play 0118`.
