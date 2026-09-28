# 1902 · Shell basics & job control

**Topic:** Theory quizzes · **Difficulty:** ★☆☆☆☆ · **Commands:** &, ^Z, bg, fg, jobs, builtins

Answer in `answer.txt` as `N: answer`.

1. Character written after a command to run it in the **background**. (character)
2. Key combination that **suspends** the foreground process. (e.g. `ctrl+x`)
3. Key combination that usually **aborts** the foreground process. (e.g. `ctrl+x`)
4. Command that resumes a suspended job **in the background**. (command)
5. Command that brings a job to the **foreground**. (command)
6. Is `cd` an internal (builtin) or external command? (internal/external)
7. Is `ls` an internal or external command? (internal/external)
8. Why must `cd` be internal? a) because it is faster b) because a child process cannot change its
   parent's current directory c) because it needs root (a/b/c)
9. Command that locates the executable, the sources and the man page of a command. (command)
10. Name of the variable with the list of directories where executables are searched. (name, no `$`)
11. Exit status of a command that finished successfully. (number)
12. Per-user configuration file read by every interactive `bash`. (file name)
13. When the shell evaluates a line, what is done first: alias expansion or wildcard (filename)
    expansion? (alias/wildcard)
14. Key combination that searches backwards in the command history. (e.g. `ctrl+x`)

---
Write your answers in `answer.txt` (one `N: answer` line per question), then run `check 1902`.
