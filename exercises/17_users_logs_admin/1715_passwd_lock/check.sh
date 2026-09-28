# checker spec for 1715 (see lib/engine.sh)
SEEDS=1
RUN_AS_ROOT=1
setup() { sudo passwd -u rmartin >/dev/null 2>&1; echo 'rmartin:lab' | sudo chpasswd; true; }
