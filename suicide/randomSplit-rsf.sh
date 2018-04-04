#!/bin/bash

limit=6
count=0

echo "[$(date)]: simulation started."
for ((process = 1; process < 201; process++))
do
    Rscript --vanilla randomSplit-rsf.R $process &
    count=$(($count + 1))
    echo "[$(date)]: process $process started."
    if [[ $count -ge $limit ]]
    then
        wait
        count=0
    fi
done

echo "[$(date)]: all done."
