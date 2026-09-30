#!/bin/bash
[ "$(echo $$)" = "$$" ] && echo same || echo different
[ "$(echo $BASHPID)" = "$$" ] && echo same || echo different
( echo $$ > sub.out ) &
wait
[ "$(cat sub.out)" = "$$" ] && echo same || echo different

