Write `sumargs.sh`: it adds all the integers it receives as arguments and prints

```
Total: 15
```

for `sumargs.sh 4 5 6`. With no arguments it prints `Total: 0`.

`"$@"` is the list of all arguments. A loop goes through it (`for n in "$@"; do ... done`) and `$(( total + n ))` does the arithmetic. Test with positive integers only.
