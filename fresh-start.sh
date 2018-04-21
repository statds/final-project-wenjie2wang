#!/bin/bash

set -e

## force a fresh start of the project files
git checkout -f

## update the repository from github
git pull origin master
git submodule update --recursive

## install and enable checkpoint for R
Rscript -e "try(remove.packages('checkpoint'), silent = TRUE)" &> /dev/null
rm -rf ~/.checkpoint
mkdir ~/.checkpoint
./docker/enable_checkpoint.R

## check the version of Python modules and R packages
cd docker/
./check_version.sh
cd ..
