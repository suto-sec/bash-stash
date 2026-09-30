# checker spec for 0344 (see lib/engine.sh)
setup() { bigfile f $(randr 1 5000); }
extra_check() { must_use stat; }
