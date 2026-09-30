#!/bin/bash
chmod -R go= privado
chmod g+x privado privado/compartir
chmod g+r privado/compartir/*.txt
stat -c '%A %n' privado privado/compartir privado/compartir/*.txt

