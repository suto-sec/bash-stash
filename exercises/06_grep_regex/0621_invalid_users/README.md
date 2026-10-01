# 0621 · Invalid users in auth.log

**Topic:** grep & regular expressions · **Difficulty:** ★★★☆☆ · **Commands:** grep -oE, cut, sort, uniq -c, head

Using the real `/var/log/auth.log`, consider only the substrings `Invalid user <name> from <ip>`
(the name has no spaces). Print, separated by `---`:

1. the **5** most tried user names, as `<count> <name>` (no leading spaces), count descending,
   ties by name ascending (as `sort` orders them)
2. the number of **distinct** names tried
3. the IP that tried the largest number of **distinct** user names, as `<count> <ip>`
   (ties: IP ascending as text, as `sort` orders them)
