Before those two lines print one line `user: N` for each user with at least one **accepted** login, sorted by user name. The user is the word after `for` (`Accepted password for ana from ...`).

Read the words of the line (`read -r -a w`): the user is `${w[8]}`. An associative array keeps one counter per user.
