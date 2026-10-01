# 1612 · Capturing two values with $( ) and read

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** $(func), read, local

`echo`+`$( )` can return more than one piece of data if you print them on one line and split them
back with `read`.

Write a function `rango` that receives numbers as arguments and **echoes** two numbers on a single
line, separated by one space: the smallest, then the largest. Capture both at once with

```
read -r menor mayor <<< "$(rango "$@")"
```

then print `menor=X mayor=Y`.
