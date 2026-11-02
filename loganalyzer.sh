#!/bin/bash

#file safety checks
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 LOGFILE">&2
    exit 1
fi

log="$1"

if [[ ! -r "$log" ]]; then
    echo "Error: $log is unreadable">&2
    exit 1
fi

if [[ ! -f "$log" ]]; then
    echo "Error: $log is not a file">&2
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
        first_digit=subtr($9, 1, 1)
        if ( $first_digit == "2" ) {c2++}
        else if ( $first_digit == "3" ) {c3++}
        else if ( $first_digit == "4" ) {c4++}
        else if ( $first_digit == "5" ) {c5++}
    }
    END {
        #if the a count is empty, print 0 instead of leaving it blank
        printf "2xx: .............. %d\" , "c2"
        printf "3xx: .............. %d\n , "c3"
        printf "4xx: .............. %d\n", "c4"
        printf "5xx: .............. %d\n", "c5"
    }'

    "$log"
}

data_sent() {
    awk '
        {sum += }
    END {
        mb = sum / 1048576
        printf "Data sent .......... %.1f MB", mb
    }'
    "$log"
}

top_pages(){
    echo "5 top pages"
    awk '{print $7}' "$log"| sort | uniq -c | sort -rn | head -5
}

top_ips(){
    echo "5 top ip pages"
    awk '{print $1}' "$log" | sort | uniq -c | sort -rn | head -5
}

top_404_pages() {
    echo "5 top 404 pages"
    awk '{print $7}' "$log" | sort | uniq -c | sort -rn | head -5
}
echo "=============================================="
echo "Log Report: $log"
echo "=============================================="

main() {
check_file "$@"

total_requests
unique_visitors
status_codes 
data_sent

echo ""
top_pages
echo ""
top_ips 
echo ""
top_404_pages 
}
main "$@"