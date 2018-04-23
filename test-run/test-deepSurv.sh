#!/bin/bash

set -e

## using two cores here
## decrease the `limit` to `1` for using a single core
limit=2
count=0

echo "[$(date)]: testing DeepSurv started."
for ((process = 1; process < 3; process++))
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
