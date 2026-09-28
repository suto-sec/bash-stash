# checker spec for 0607 (see lib/engine.sh)
setup() { local i; for i in $(seq 25); do case $(rand 7) in 0) echo "$(pick ABC XYZ QWE)-$(randr 1 99999)";; 1) echo "$(pick AB ABCD abc)-$(randr 10 99)";; 2) echo "$(pick x xx xxx '')y$(word)";; 3) pick colour color colouur colr;; 4) echo "$(word)xy";; 5) echo "$(pick A B)$(pick C D)$(pick E F)-$(randr 10 9999)";; *) word;; esac; done > codigos.txt; }
