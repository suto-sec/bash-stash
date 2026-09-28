#!/bin/bash
cat > config.ini << EOF
[usuario]
nombre=$USER
home=$HOME
EOF
cat >> config.ini << 'EOF'
[notas]
# $HOME is not expanded here
precio=5$
EOF

