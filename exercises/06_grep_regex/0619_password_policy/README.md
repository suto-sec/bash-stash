# 0619 · A password policy with POSIX classes

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep, [[:digit:]] [[:upper:]] [[:lower:]] [[:punct:]], grep -E {n,}

`candidatas.txt` contains one candidate password per line (no spaces). Print the candidates that
satisfy **all** these rules, in the order of the file:

- at least 8 characters long
- at least one digit, at least one uppercase letter and at least one lowercase letter
- at least one punctuation character (`[[:punct:]]`, e.g. `! . # _ @ %`)

Then print `---` and the **number** of rejected candidates.

Hint: one `grep` per rule, chained with pipes, using the POSIX classes.

---
Write your solution in `answer.sh`, then run `check 0619`.  
To experiment with the same test files the checker uses: `play 0619`.
