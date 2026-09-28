#!/bin/bash
ls $(cat nombres.txt) > ok.txt 2> errores.txt
echo "ok: $(wc -l < ok.txt)"
echo "errores: $(wc -l < errores.txt)"

