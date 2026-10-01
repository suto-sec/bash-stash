# 0924 · newuser.sh (prompts on stderr, answers from stdin)

**Topic:** Redirection: > >> 2> < << <<< · **Difficulty:** ★★★★☆ · **Commands:** printf >&2, read -r, grep -qx, cat > file << EOF

Write `newuser.sh`:

```
newuser.sh OUTFILE
```

It asks three questions and reads the answers from **stdin**, one line each: login, full name and
shell. Before reading each answer it prints the prompt on **stderr**, without a newline:
`Login: `, `Full name: `, `Shell: ` (so that the stdout of the script stays clean; note that
`read -p` shows nothing when stdin is not a terminal). On success, stderr must contain **exactly**
`Login: Full name: Shell: `.

Then it validates, in this order:

- stdin ended before the three answers were read → exit **5**
- the login is not a lowercase letter followed by 1 to 7 lowercase letters or digits, or the full
  name is empty → exit **3**
- the shell is not a line of `/etc/shells` (exactly) → exit **4**

and on success writes `OUTFILE` with a here document:

```
login=<login>
name=<full name>
shell=<shell>
home=/home/<login>
```

and prints on stdout `User <login> saved to <OUTFILE>`.

Before asking anything: not exactly one argument → usage, exit **1**; `OUTFILE` already exists →
exit **2** (it must not be modified). All errors print a message on **stderr** and do not create `OUTFILE`.
