# 1442 · Quick refresher: test / [ ]

**Topic:** test, if & case · **Difficulty:** ★☆☆☆☆ · **Commands:** test, [ ]

`[ -e PATH ]` is true if the path exists (a file or a directory).

The script receives one argument: a path. Print `exists` if that path exists, and `missing` if it does not.

Examples: the checker runs it with `fichero` (a file that exists) and with `noexiste` (nothing with that name).

```
exists
missing
```

Hint:

```
if [ -e "$1" ]; then
  echo ...
else
  echo ...
fi
```

---
Write your solution in `answer.sh`, then run `check 1442`.  
To experiment with the same test files the checker uses: `play 1442`.
