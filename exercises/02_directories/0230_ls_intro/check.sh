# checker spec for 0230 (see lib/engine.sh)
setup() { mkdir d; touch "d/$(word)" "d/.$(word)rc"; }
filter() { sed -E 's/ [A-Z][a-z]{2} +[0-9]+ +([0-9]{2}:[0-9]{2}|[0-9]{4}) / DATE /'; }
extra_check() { must_use ls; }
