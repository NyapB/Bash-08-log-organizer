#!/bin/bash

#file safety checks
if [[ -z "$1" ]]; then
    echo "Usage: $0 LOGFILE"
    exit 1
fi

log="$1"

if [[ ! -r "$1" ]]; then
    echo "Error: $log is unreadable"
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
    unique=$(awk "{print $1}" "$log" | sort | uniq | wc -l)
    echo "Unique Visitors : $unique"
}

status_codes(){
    awk "{
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
    }"
    "$log"
}

data_sent() {
    awk "
        {sum += }
    END {
        mb = sum / 1048576
        printf "Data sent %.1f MB", mb
    }"
    "$log"
}

top_pages(){
    echo "5 top pages"
    awk "{print $7}" $log | sort | uniq -c | sort -rn | head -5
}

top_ips(){
    echo "5 top ip pages"
    awk "{print $1}" $log | sort | uniq -c | sort -rn | head -5
}

top_404_pages() {
    echo "5 top 404 pages"
    awk "{print $7}" $log | sort | uniq -c | sort -rn | head -5
}
echo "=============================================="
echo "Log Report: $log"
echo "=============================================="

total_requests
unique_visitors
status_codes "$@"

echo ""
top_pages "$@"
echo ""
top_ips "$@"
echo ""
top_404_pages "$@"