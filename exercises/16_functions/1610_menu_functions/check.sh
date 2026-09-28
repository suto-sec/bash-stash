# checker spec for 1610 (see lib/engine.sh)
SEEDS=4
COMPARE="stdout exit files"
input() { local i; for i in $(seq "$(randr 3 8)"); do case $(rand 5) in 0|1) echo "add $(words 3)";; 2) echo list;; 3) echo "del $(randr 1 4)";; 4) echo "$(pick foo help)";; esac; done; echo list; [[ $(rand 2) == 1 ]] && echo quit; echo "add after quit"; }
