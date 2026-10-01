# 1208 · Processes that ignore SIGTERM

**Topic:** Processes, jobs & signals · **Difficulty:** ★★★★☆ · **Commands:** kill, kill -9, kill -0, trap (in the provided script)

`terco.sh` is a provided script that **ignores SIGTERM**. Start it in the background, then:

1. `sleep 0.3` and send it SIGTERM; `sleep 0.3` and print `alive` or `dead` (`kill -0`)
2. send it SIGKILL (`-9`), `wait` for it (hide messages) and print `alive`/`dead` again
3. print the exit status returned by `wait`
