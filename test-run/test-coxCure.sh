#!/bin/bash

set -e

## only using one core for testing
limit=1
count=0

printf "[$(date)]: testing cox cure model.\n"
for ((process = 1; process < 3; process++))
do
    Rscript --vanilla test-coxCure.R $process &
    count=$(($count + 1))
    echo "[$(date)]: process $process started."
    if [[ $count -ge $limit ]]
    then
        wait
        count=0
    fi
done

printf "[$(date)]: testing cox cure model was done.\n"
