#!/bin/bash
find registros -type f ! -path '*/descartados/*' -exec grep -qx ERROR {} \; -print | sort

