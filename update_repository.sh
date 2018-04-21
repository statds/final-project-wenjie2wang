#!/bin/bash

if git diff-index --quiet HEAD --; then
    ## if no changes then try to pull the updates to local
    git pull origin master
    git submodule update --recursive
    printf "The reposity is up-to-date!\n\n"
else
    ## if there is any modification
    printf "The reposity contains modification!\n\n"
fi
