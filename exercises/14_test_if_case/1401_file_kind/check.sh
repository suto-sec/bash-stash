# checker spec for 1401 (see lib/engine.sh)
SEEDS=1
setup() { touch fichero; mkdir dir; ln -s fichero enlace; ln -s noexiste roto; }
ARGS=('fichero' 'dir' 'enlace' 'roto' 'noexiste' '/dev/null' '/etc/passwd' '/')
