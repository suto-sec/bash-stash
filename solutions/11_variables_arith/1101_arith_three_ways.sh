#!/bin/bash
DATOA=25
DATOB=4
expr $DATOA \* $DATOB + 5
echo "$DATOA * $DATOB + 5" | bc
echo $((DATOA * DATOB + 5))

