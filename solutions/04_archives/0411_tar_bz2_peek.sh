#!/bin/bash
tar -cjf entrega.tar.bz2 trabajo
tar -tjf entrega.tar.bz2 | sort
echo ---
tar -tjf entrega.tar.bz2 | wc -l

