## About

This directory contains source code for testing the computing environment.


## Usage

A simple Makefile is available for easily conducting a test run.  Calling
`make` in the terminal under this directory runs the default receipt (`all`).
Alternatively, it is possible to conduct the simulation studies step by step.
Other phony receipts include

- `data` for generating simulated datasets
- `coxCure` for testing the Cox cure model
- `rsf` for testing the RSF model
- `deepSurv` for testing the DeepSurv model
- `Tensorboard` for watching the model fitting progress of the DeepSurv model
  at `localhost:6006`
- `clean` for cleaning all the logs, temp files, and testing results
