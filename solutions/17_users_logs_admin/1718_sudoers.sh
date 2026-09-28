#!/bin/bash
cat > lab_sudoers << 'EOF'
%devs ALL=(root) NOPASSWD: /usr/bin/systemctl restart cups
luke ALL=(root) PASSWD: /bin/kill, NOPASSWD: /bin/ls
jgarcia ALL=(ALL:ALL) ALL
EOF
visudo -c -f lab_sudoers
