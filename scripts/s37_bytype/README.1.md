Write `bytype.sh DIR`. It looks at the **regular files directly inside** `DIR` (hidden files are not listed by `*`, and directories do not count) and prints four lines, always in this order:

```
text: 4      (.txt and .md)
code: 3      (.c, .sh and .py)
image: 3     (.png and .jpg)
other: 2     (anything else)
```
