# 0120 · genmv.sh: printing a safely quoted rename script

**Topic:** Echo, quoting & substitution · **Difficulty:** ★★★★☆ · **Commands:** printf, ${v//\'/...}, ${v##*.}, for f in "$DIR"/*

Write `genmv.sh`:

```
genmv.sh DIR PREFIX
```

It does **not** rename anything: it **prints** a bash script that would rename every **regular file
directly inside** `DIR` (not hidden, not recursive, in the order of the `*` glob) to
`PREFIX_NNN.EXT`, where `NNN` is a counter starting at `001` (3 digits, zero-padded) and `EXT` is the
original extension (the text after the **last** dot of the name, kept as is). Names without a dot get
no extension (`PREFIX_NNN`).

Output format:

```
#!/bin/bash
mv -- 'DIR/old name.jpg' 'DIR/PREFIX_001.jpg'
mv -- 'DIR/README' 'DIR/PREFIX_002'
# 2 files
```

- `DIR` is written exactly as it was given.
- **Every** path is enclosed in single quotes, so that spaces, `$`, `*`... are safe. A single quote
  inside a name cannot appear inside single quotes: write it as `'\''` (close the quotes, an escaped
  quote, reopen), e.g. the file `it's.txt` becomes `'DIR/it'\''s.txt'`.
- The last line is `# N files`.

Errors (message on **stderr**, nothing on stdout), checked in this order:

- not exactly 2 arguments: usage, exit **1**
- `DIR` is not a directory: exit **2** (mention it)
- `PREFIX` is empty or contains something other than letters, digits, `_` and `-`: exit **3**
- `DIR` contains no regular files: exit **4**
