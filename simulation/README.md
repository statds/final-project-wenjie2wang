## About

This directory contains source code for simulation studies that are not
included in the final report.


## Simulation Settings

We considered simulating survival data with severe censoring and a large cure
fraction. We randomly generated totally ten covariates, $x_1,\ldots,x_{10}$,
following Uniform$(-1, 1)$ and only $x_1$ and $x_2$ were used for simulating
event times from Weibull model. The shape and scale parameter of the Weibull
model was set to be $1.5$ and $0.01$, respectively. The covariate coefficients
were set to be $\beta_1 = 1$ and $\beta_2 = 2$. The censoring times were
simulated from Uniform$(0, 10)$. An intercept term, $z_0$, and one covariate,
$z_1$, randomly generated from Uniform$(0, 1)$ were used for simulating the cure
indicators from the logistics model. The coefficients were both set to be $1$.
The resulting cure rate and censoring rate was about $73.1\%$ and $85.5\%$ on
average. Totally 1,000 simulated datasets were generated.

It is straightforward to adjust and design new settings based on the existing
scripts.


## Usage

A simple Makefile is available for easily conducting the simulation studies.
Calling `make` in the terminal under this directory runs the default receipt
(`all`), which reproduces the whole simulation process including generating
data, fitting models and summarizing all the results.

Alternatively, it is possible to conduct the simulation studies step by step.
Other phony receipts include

- `data` for generating simulated datasets
- `coxCure` for simulation studies for the Cox cure model only
- `rsf` for simulation studies for the RSF model only
- `deepSurv` for simulation studies for the DeepSurv model only
- `summary` for summarizing all the results
- `Tensorboard` for watching the model fitting progress of the DeepSurv model
  at `localhost:6006`
- `clean` for cleaning all the logs and temp files
- `cleanAll` for cleaning all the logs, temp files, and all the simulation
  results
