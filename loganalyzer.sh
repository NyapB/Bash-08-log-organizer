#!/bin/bash

#file safety checks
if [[ -z "$1" ]]; then
    echo "Usage: $0 LOGFILE"
    exit 1
fi

log="${1 :?Usage: $0 LOGFILE}"

if [[ ! -r "$1" ]]; then
    echo "Error: $LOGFILE is unreadable"
    exit 1
fi

if [[ ! -s "$1" ]]; then
    echo "Error: $log contains no data"
    exit 1
fi

echo "=============================================="
echo "Log Report: $log"
echo "=============================================="