# 1730 · Synchronising a group with a list (as root)

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★★☆ · **Commands:** getent group, groupadd, gpasswd -a -d, id, cut, tr

This script runs **as root**. Write `equipo.sh GROUP FILE`, which makes the supplementary members of
`GROUP` (4th field of its `/etc/group` line) be **exactly** the users listed in `FILE` (one name per
line; empty lines are ignored):

1. if `GROUP` doesn't exist, create it and print `Group <GROUP> created`
2. for each name of `FILE`, in file order:
   - not an existing user: print `unknown user <name>` on **stderr** and ignore it
   - already a member: nothing
   - otherwise add it to the group and print `+ <name>`
3. then, for each current member that is **not** in `FILE`, in the order of the member list:
   remove it from the group and print `- <name>`
4. finally print `<GROUP>: added A, removed R, members: <list>` where `<list>` is the final members
   **sorted** and joined with commas, or `(none)`

Only these lines may appear on stdout (`gpasswd` talks: silence it).
Exit codes: not exactly 2 arguments → usage on stderr, **1**; `FILE` not readable → **2**;
**3** if there were unknown users, **0** otherwise. Other groups of the users must not change.

---
Write your solution in `answer.sh`, then run `check 1730`.  
To experiment with the same test files the checker uses: `play 1730`.
