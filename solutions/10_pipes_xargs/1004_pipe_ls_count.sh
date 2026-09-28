#!/bin/bash
ls -l | grep -c '^d'
ls -l | grep -c '^-'
ls -l | tail -n +2 | cut -c3 | grep -c w
ls -l | grep '^-' | cut -c3 | grep -c w

