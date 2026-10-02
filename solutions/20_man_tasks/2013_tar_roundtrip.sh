#!/bin/bash
tar -czf copia.tgz datos
mkdir restaurado
tar -xzf copia.tgz -C restaurado

