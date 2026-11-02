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

#functions
total_requests(){
    total=$(wc -l < "$log")
    echo "Total requests: $total"
}

unique_visitors(){
    unique=$(awk '{print $1}' "$log" | sort | uniq | wc -l)
    echo "Unique Visitors : $unique"
}

status_codes(){
    awk '{
        first_digit = subtr($9, 1, 1)
        if (( first_digit == "2")) {c2++}
        elif (( first_digit == "3")) {c3++}
        elif (( first_digit == "4")) {c4++}
        elif (( first_digit == "5")) {c5++}
    }
    END {
        #if the a count is empty, print 0 instead of leaving it blank
        printf "2xx / 3xx %d / %d\n", c2, c3
        printf "2xx / 3xx %d / %d\n", c2, c3
    }'
    "$log"
}
echo "=============================================="
echo "Log Report: $log"
echo "=============================================="

total_requests
unique_visitors
status_codes