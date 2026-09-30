# 1617 · Sourcing a second function library

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** source, functions

The provided file `lib_texto.sh` defines two functions: `contar_vocales STR` (**echoes** the
number of vowels — `aeiouAEIOU` — in STR) and `es_largo STR N` (**returns** 0 if STR has at least
N characters, 1 otherwise).

**Source it** (`source ./lib_texto.sh`) and, for each script argument, print
`V: C vocales, largo` if `es_largo "V" 5` succeeds, or `V: C vocales, corto` otherwise (C is the
vowel count from `contar_vocales`). Don't redefine either function.

---
Write your solution in `answer.sh`, then run `check 1617`.  
To experiment with the same test files the checker uses: `play 1617`.
