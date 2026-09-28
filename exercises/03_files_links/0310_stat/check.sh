# checker spec for 0310 (see lib/engine.sh)
setup() { bigfile a $(randr 0 3000); bigfile b $(randr 0 50); bigfile c $(randr 0 9); chmod "$(pick 600 640 644 700)" a; chmod "$(pick 755 750 444)" b; [[ $(rand 2) == 1 ]] && ln c c2; true; }
extra_check() { must_use stat; }
