#!/bin/bash
split -l 10 -d grande.txt parte_
ls parte_* | wc -l

