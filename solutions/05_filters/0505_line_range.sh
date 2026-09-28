#!/bin/bash
read A B < rango.txt
head -n "$B" libro.txt | tail -n $((B - A + 1))

