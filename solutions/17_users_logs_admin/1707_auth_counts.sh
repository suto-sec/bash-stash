#!/bin/bash
L=/var/log/auth.log
echo "failed passwords: $(grep -c 'Failed password' $L)"
echo "invalid users: $(grep -c 'Invalid user' $L)"
echo "accepted logins: $(grep -c 'Accepted ' $L)"
echo "sudo commands: $(grep -c 'COMMAND=' $L)"
echo "telnet connections: $(grep -c 'in.telnetd' $L)"

