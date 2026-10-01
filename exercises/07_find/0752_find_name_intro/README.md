# 0752 · Quick refresher: find -name

**Topic:** find · **Difficulty:** ★☆☆☆☆ · **Commands:** find -name

`find DIR -name PATTERN` looks inside `DIR` (and all its subdirectories) for files with that name.

Under the directory `data`, print the path of every file called `notes.txt` (there are several, in different subdirectories). Put the paths in alphabetical order, one per line, by piping the result of `find` into `sort`.

Expected output:

```
data/a/notes.txt
data/b/c/notes.txt
data/notes.txt
```

Hint: `find data -name 'notes.txt' | sort`. Always put the name pattern in quotes, so the shell does not expand it.

---
Write your solution in `answer.sh`, then run `check 0752`.  
To experiment with the same test files the checker uses: `play 0752`.
