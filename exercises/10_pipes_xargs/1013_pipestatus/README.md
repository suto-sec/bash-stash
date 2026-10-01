# 1013 · Exit codes in pipelines

**Topic:** Pipes, xargs & command substitution · **Difficulty:** ★★★★☆ · **Commands:** $?, PIPESTATUS, set -o pipefail

1. Run `grep zzz noexiste.txt 2>/dev/null | wc -l` and print the pipeline output.
2. Print the exit code of the **whole pipeline** (`$?`) — it's the exit code of the **last** command.
3. Run the same pipeline again and print the exit codes of **every** command, separated by a space,
   using `${PIPESTATUS[@]}`.
4. Enable `set -o pipefail`, run it once more (print its output) and print `$?` again.
