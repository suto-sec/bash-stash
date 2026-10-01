Write `ext.sh NAME`. It looks only at the **end of the name** and prints `NAME: kind`:

| the name ends in | kind |
|------------------|------|
| `.txt` | `text` |
| `.sh` | `script` |
| `.png` or `.jpg` | `image` |
| anything else | `other` |

```
ext.sh photo.png   ->   photo.png: image
```

This is a job for `case "$1" in *.txt) ... ;; esac`.
