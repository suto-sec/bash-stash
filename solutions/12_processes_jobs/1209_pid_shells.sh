#!/bin/bash
[ "$(bash pid.sh)" = "$$" ] && echo same || echo different
[ "$(source pid.sh)" = "$$" ] && echo same || echo different
[ "$( echo $BASHPID )" = "$$" ] && echo same || echo different

