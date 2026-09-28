#!/bin/bash
{
  echo "== informe =="
  ls docs/*.txt | wc -l
  ls docs | grep '\.txt$' | sort
  echo "== fin =="
} > informe.txt
echo hecho

