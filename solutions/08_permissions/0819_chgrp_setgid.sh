#!/bin/bash
chgrp adm logs/*.log
chgrp -R secops equipo
find equipo -type d -exec chmod g+s {} +
touch equipo/nuevo.txt equipo/sub/otro.txt
stat -c '%G %n' equipo/nuevo.txt equipo/sub/otro.txt

