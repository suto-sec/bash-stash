`pad.sh -w W FILE` uses `W` digits instead of 3. `W` must be an integer from 1 to 9, otherwise an error that includes it and exit code **3**. `-w` needs `W` and `FILE` after it (otherwise the usage error). The numbers never get shorter than `W` and are not cut when longer.

`printf "%0${w}d"`.
