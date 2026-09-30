#!/bin/bash
tr 'A-Z' 'a-z' | tr -cs 'a-z0-9\n' '-' | sed 's/^-//; s/-$//'

