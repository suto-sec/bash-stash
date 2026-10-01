# 0550 · leaderboard.sh (ranking of players)

**Topic:** Filters: wc, head, tail, cut, sort, uniq, tr, sed, tee... · **Difficulty:** ★★★★☆ · **Commands:** tail -n +2, cut, sort -u, sort -t -k (several keys), grep -c, head, nl

Write `leaderboard.sh`:

```
leaderboard.sh SCORES [N]
```

`SCORES` starts with a header line (ignore it); every other line is `player;game;score` (player
names may contain spaces; score is a non-negative integer). For every player compute their
**best** score and the number of **games** (lines) they played. Print the top `N` players
(default **3**; all of them if there are fewer) ranked by:

1. best score, descending
2. then number of games, descending
3. then player name (in `sort` order)

in this format (the rank starts at 1):

```
<rank>. <player>: best <score>, games <n>
```

Finally print `Players: P, games: G` (P = different players, G = data lines). Player names must be
compared exactly (`Ana` is not `Ana Maria`).

Errors (message on **stderr**, nothing on stdout), checked in this order:

- not 1 or 2 arguments: error and usage, exit **1**
- `SCORES` is not a readable regular file: message with its name, exit **2**
- `N` is not a positive integer: message, exit **3**
