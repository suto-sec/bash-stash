# 1909 · What does it print?

**Topic:** Theory quizzes · **Difficulty:** ★★★☆☆ · **Commands:** quoting, expansions, exit codes

Answer in `answer.txt` as `N: answer` with **exactly** what the snippet prints (one line each).
Don't run them until you have answered!

1. `A=5; echo '$A'`
2. `A=5; echo "$A$A"`
3. `echo $((7 / 2))`
4. `echo $((17 % 5))`
5. `X=hola; echo ${#X}`
6. `set -- a "b c" d; echo $#`
7. `f() { return 3; }; f; echo $?`
8. `false || echo no`
9. `true && echo yes || echo no`
10. `echo {1..4}`
11. `F=informe.tar.gz; echo ${F%%.*}`
12. `F=informe.tar.gz; echo ${F#*.}`
13. `for i in a b c; do echo -n $i; done; echo`
14. `expr 3 + 4 \* 2`
15. `[[ 10 > 9 ]] && echo ok || echo ko`   (careful: inside `[[ ]]`, `>` compares **strings**)
16. `[ 10 -gt 9 ] && echo ok || echo ko`
17. `V=; echo "[${V:-vacio}]"`
18. `echo "$(echo uno; echo dos)" | wc -l`
