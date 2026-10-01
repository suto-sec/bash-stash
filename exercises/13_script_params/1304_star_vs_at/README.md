# 1304 · "$*" vs "$@"

**Topic:** Script parameters & exit codes · **Difficulty:** ★★★☆☆ · **Commands:** "$*", "$@", IFS

Print:

1. how many words `for x in "$*"` iterates over (always 1 if there is at least one argument; 0 if none)
2. how many words `for x in "$@"` iterates over
3. how many words `for x in $*` iterates over (unquoted: arguments are split again!)
4. all arguments joined by commas, using `IFS=,` and `"$*"` (inside a subshell or restore IFS)
