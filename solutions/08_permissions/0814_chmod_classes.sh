#!/bin/bash
chmod g=u,o=g,o-w equipo/*
stat -c '%a %n' equipo/*

