# 1614 · Forwarding "$@" through a wrapper function

**Topic:** Functions · **Difficulty:** ★★★☆☆ · **Commands:** "$@" vs $*, functions calling functions

Write a function `contar` that receives the script's arguments as **separate** parameters and
prints `N args:` (N = its own `$#`), followed by one line per argument:
`- 'V' (L chars)` (V = the argument exactly as received, L = `${#V}`).

Write a function `mostrar` that receives the script's arguments and simply **forwards** them to
`contar`, using `"$@"` — never `$*` — so arguments with embedded spaces stay as a single argument
each. Call `mostrar "$@"`.

---
Write your solution in `answer.sh`, then run `check 1614`.  
To experiment with the same test files the checker uses: `play 1614`.
