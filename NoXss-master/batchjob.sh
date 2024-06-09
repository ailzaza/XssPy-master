#!/bin/bash

#Scan big data in batch to avoid highly use of cpu&memory.
python3 start.py --file url --filter
line=`cat url.filtered | wc -l`
if [ $line -lt 10000 ]
then
    python3 start.py --file url.filtered
else
    start=1
    count=10000
    end=10000
    while [ $end -lt $line ]
    do
        sed -n "$start,$end p" url.filtered > url.slice
        # delete traffic files after scanning.
        python3 start.py --file url.slice --clear
        start=$((start + count))
        end=$((end + count))
    done
    sed -n "$start,$line p" url.filtered > url.slice
    # delete traffic files after scanning.
    python3 start.py --file url.slice --clear
    cat urls.slice
fi