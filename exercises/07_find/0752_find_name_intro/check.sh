# checker spec for 0752 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p data/{a,b/c}; touch data/notes.txt data/a/notes.txt data/b/c/notes.txt data/a/notes.md data/other.txt; }
