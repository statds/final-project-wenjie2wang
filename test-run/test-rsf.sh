#!/bin/bash

limit=1
count=0

echo "[$(date)]: testing randomForestSRC started."
for ((process = 1; process < 3; process++))
do
    Rscript --vanilla test-rsf.R $process &
    count=$(($count + 1))
    echo "[$(date)]: process $process started."
    if [[ $count -ge $limit ]]
    then
        wait
        count=0
    fi
done

echo "[$(date)]: testing randomForestSRC was done."
