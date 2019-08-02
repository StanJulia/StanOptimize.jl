# StanOptimize.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/examples/StanOptimize.jl.svg?branch=master)](https://travis-ci.com/StanJulia/StanOptimize.jl)
[![codecov.io](http://codecov.io/github/StanJulia/StanOptimize.jl/coverage.svg?branch=master)](http://codecov.io/github/StanJulia/StanOptimize.jl?branch=master)

## Important note

### Refactoring CmdStan.jl v6. Maybe this is an ok approach.

## Installation

This package is registered. Install with

```julia
pkg> add StanOptimize
```

You need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["JULIA_CMDSTAN_HOME"] = expanduser("~/src/cmdstan-2.19.1/") # replace with your path
```

This package is derived from Tamas Papp's [StanRun.jl]() package.

## Usage

It is recommended that you start your Julia process with multiple worker processes to take advantage of parallel sampling, eg

```sh
julia -p auto
```

Otherwise, `stan_sample` will use a single process.

Use this package like this:

```julia
using StanOptimize
```

See the docstrings (in particular `?StanOptimize`) for more.
