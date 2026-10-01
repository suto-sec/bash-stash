# 1903 · Inodes, links & permissions

**Topic:** Theory quizzes · **Difficulty:** ★★☆☆☆ · **Commands:** ln, chmod, umask, ls -l

Answer in `answer.txt` as `N: answer`.

1. Structure where a file's attributes (owner, dates, permissions, block list) are stored. (one word)
2. Link count of a newly created regular file. (number)
3. After `ln a b`, the link count of `a`. (number)
4. After `ln a b; rm a`, can you still read the data through `b`? (yes/no)
5. After `ln -s a c; rm a`, can you still read the data through `c`? (yes/no)
6. Octal value of `rwxr-x--x`. (3 digits)
7. With `umask 027`, permissions of a new **file** in octal. (3 digits)
8. With `umask 027`, permissions of a new **directory** in octal. (3 digits)
9. With `umask 0174`, permissions of a new file in octal (a classic example). (3 digits)
10. Which permission on a **directory** allows going through it (`cd`)? (r/w/x)
11. Which permission on a directory allows **creating** entries in it? (r/w/x)
12. First character of `ls -l` for a symbolic link. (character)
13. Who can change the permissions of a file? a) only root b) its owner (and root) c) anyone with
    write permission (a/b/c)
14. In `find`, which one means "**all** of these bits set": `-perm -111` or `-perm /111`? (write it)
15. What does the capital `X` in `chmod a+X` do? a) sets execute on everything b) sets execute only
    on directories and on files that already have some execute bit c) removes execute (a/b/c)
