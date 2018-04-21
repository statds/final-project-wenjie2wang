#!/bin/bash

printf "The version of installed Python modules is given below:\n\n"
pip3 show theano lasagne lifelines matplotlib tensorboard_logger

printf "\n\nThe version of installed R packages is given below:\n\n"
./check_version.R
