# 1904 · Redirection & pipes semantics

**Topic:** Theory quizzes · **Difficulty:** ★★☆☆☆ · **Commands:** > >> 2> 2>&1 | tee xargs

Answer in `answer.txt` as `N: answer`.

1. Operator that **appends** stdout to a file. (operator)
2. File descriptor number of stderr. (number)
3. With `cmd > f 2>&1`, where does stderr end? a) in f b) on the screen (a/b)
4. With `cmd 2>&1 > f`, where does stderr end? a) in f b) on the screen (a/b)
5. Special file that discards everything written to it. (path)
6. Does `wc -l < file` print the file name? (yes/no)
7. A pipe connects the stdout of the left command to the ____ of the right command. (stdin/stdout/stderr)
8. Command that copies its stdin both to stdout and to a file. (command)
9. Command that builds command-line arguments from its stdin. (command)
10. Older (backquote) syntax equivalent to `$(cmd)`: write it for `cmd`. (write it)
11. What does `cat <<< "hola"` print? (text)
12. By default, the exit status of a pipeline is the status of which command? (first/last)
13. Bash option that makes a pipeline fail if **any** command fails. (write the `set` command)
14. In a here document, how do you prevent `$VAR` from being expanded? a) quote the delimiter
    (`<< 'EOF'`) b) use `<<-` c) it cannot be prevented (a/b/c)
