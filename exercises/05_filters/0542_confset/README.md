# 0542 · confset.sh (read or change a setting in place)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** grep, sed -i, sed s|||, echo >>, [[ =~ ]]

Write `confset.sh`:

```
confset.sh FILE KEY [VALUE]
```

`FILE` is a configuration file with lines `KEY=VALUE`; lines starting with `#` are comments. An
**active** line for a key is a line that starts exactly with `KEY=`; a **disabled** line is one
that starts exactly with `#KEY=` (there is at most one per key). `PORT=` must not match `MYPORT=`
or `PORT2=`, and comment text such as `# PORT is...` is not a disabled line.

- **Without VALUE** (read): print the value of the **first** active line of `KEY` (everything after
  the first `=`). If there is no active line (a disabled one does not count): message on stderr,
  exit **3**.
- **With VALUE** (write), modifying `FILE` in place:
  - if there are active lines for `KEY`: replace the value in **all** of them → print `KEY=VALUE (updated)`
  - else, if there is a disabled line: turn it into `KEY=VALUE` → print `KEY=VALUE (enabled)`
  - else: append the line `KEY=VALUE` at the end of the file → print `KEY=VALUE (added)`

  Nothing else in the file changes. Values may contain letters, digits, spaces and `. / : -`.

Errors (message on **stderr**, file unchanged), checked in this order:

- not 2 or 3 arguments: error and usage, exit **1**
- `FILE` is not an existing regular file: message with its name, exit **2**
- `KEY` is not a valid name (a letter or `_`, then letters, digits or `_`): message with the key, exit **4**

---
Write your solution in `answer.sh`, then run `check 0542`.  
To experiment with the same test files the checker uses: `play 0542`.
