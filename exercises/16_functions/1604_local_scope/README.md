# 1604 · local vs global variables

**Topic:** Functions · **Difficulty:** ★★☆☆☆ · **Commands:** local

Write the script below step by step, **predicting** each output line before running it:

1. `X=global`, `Y=global`
2. define function `f` that does `local X=local_f` and `Y=changed_by_f`, then prints `in f: X=$X Y=$Y`
3. print `before: X=$X Y=$Y`, call `f`, print `after: X=$X Y=$Y`
4. set `Y=reset`, then run `R=$(f)` and print `$R`
5. print `subshell: Y=$Y` — the change made inside `$( )` is lost, because it ran in a subshell
