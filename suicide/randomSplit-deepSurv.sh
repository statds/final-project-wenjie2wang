#!/bin/bash

limit=4
count=0

echo "[$(date)]: simulation started."
for ((process = 1; process < 201; process++))
do
    python3 randomSplit-deepSurv.py $process &
    count=$(($count + 1))
    echo "[$(date)]: process $process started."
    if [[ $count -ge $limit ]]
    then
        wait
        count=0
    fi
done

echo "[$(date)]: all done."
