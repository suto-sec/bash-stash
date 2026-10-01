Write `echoargs.sh`. It prints each of its arguments on its own line, preceded by its position and a colon:

```
echoargs.sh red "dark blue"   ->   1: red
                                   2: dark blue
```

Keep a counter in the loop: `i=$((i + 1))`.
