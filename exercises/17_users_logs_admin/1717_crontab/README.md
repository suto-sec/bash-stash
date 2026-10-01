# 1717 · Scheduling ipLog.sh with cron

**Topic:** Users, groups, sessions, logs & cron · **Difficulty:** ★★★☆☆ · **Commands:** crontab -l, crontab -, cron syntax

We want to run `ipLog.sh` **every 4 hours**, saving the results in a log. Install, for your
user, a crontab entry that:

- runs `ipLog.sh` located in your home directory (write the **absolute** path: the value of `$HOME`)
- every 4 hours, at minute 0 (00:00, 04:00, 08:00...)
- **appends** both stdout and stderr to `ipLog.log` in your home

Your current crontab already contains other entries (the checker adds one): **keep them**.
Hint: `(crontab -l; echo "0 */4 * * * ...") | crontab -`

Nothing needs to be printed. (Writing to `/var/log/ipLog.log` instead would require root.)
