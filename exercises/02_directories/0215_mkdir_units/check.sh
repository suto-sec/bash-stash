# checker spec for 0215 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { printf '%s %s\n%s\n' "$(word)" "$(word)" "$(randr 3 12)" > course.txt; mkdir -p "$(word) old"; }
