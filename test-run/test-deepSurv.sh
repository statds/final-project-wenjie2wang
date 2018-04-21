#!/bin/bash

limit=1
count=0

echo "[$(date)]: testing DeepSurv started."
for ((process = 1; process < 2; process++))
do
    python3 test-deepSurv.py $process &
    count=$(($count + 1))
    echo "[$(date)]: process $process started."
    if [[ $count -ge $limit ]]
    then
        wait
        count=0
    fi
done

echo "[$(date)]: testing DeepSurv was done."
