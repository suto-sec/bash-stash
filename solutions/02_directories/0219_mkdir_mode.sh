#!/bin/bash
mkdir -m 700 privado
mkdir -p -m 750 web/html/img
mkdir -m 1733 buzon
stat -c '%A %n' privado web web/html web/html/img buzon

