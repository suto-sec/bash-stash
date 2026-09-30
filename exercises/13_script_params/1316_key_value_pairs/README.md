# 1316 · Consuming arguments two by two

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** shift 2, while [ $# -gt 0 ], $#

The script receives `key value` pairs: `pairs.sh key1 value1 key2 value2 ...`. For each pair print
`key = value`, and at the end `N pairs` (with no arguments just print `0 pairs`).

**Validate everything before printing anything** (message on stderr, exact text):

1. odd number of arguments: `Odd number of arguments (N)`, exit **1**
2. an empty key (`""`): `Empty key at position P`, exit **2**, where P is the position of that
   argument (1-based) among all arguments; report the first one. Values may be empty.

Process the pairs with a `while [ $# -gt 0 ]` loop and `shift 2`.

---
Write your solution in `answer.sh`, then run `check 1316`.  
To experiment with the same test files the checker uses: `play 1316`.
