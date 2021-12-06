# StanOptimize.jl

| **Project Status**          |  **Build Status** |
|:---------------------------:|:-----------------:|
|![][project-status-img] | ![][CI-build] |

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/StanOptimize.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/StanOptimize.jl/stable

[CI-build]: https://github.com/stanjulia/StanOptimize.jl/workflows/CI/badge.svg?branch=master

[issues-url]: https://github.com/stanjulia/StanOptimize.jl/issues

[project-status-img]: https://img.shields.io/badge/lifecycle-stable-green.svg

## Important note

StanOptimize.jl v3 is a breaking change.

While in StanOptimize.jl v2 one could select Bfgs as optimization algorithm:
```Julia
 om = OptimizeModel("bernoulli",  bernoulli_model;
  method=StanOptimize.Optimize(;method=StanOptimize.Bfgs()),
  #tmpdir = joinpath(@__DIR__, "tmp"));
  tmpdir = mktempdir());
rc = stan_optimize(om; data, init)
```

In StanOptimize.jl v3:
```Julia
om = OptimizeModel("bernoulli",  bernoulli_model)
rc = stan_optimize(om; data, init, algorithm=:bfgs)
```

See `??OptimizeModel` and `??stan_optimize`.

## Installation

This package is registered. Install with

```julia
pkg> add StanOptimize
```

You need a working [cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in either `CMDSTAN` or JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["CMDSTAN"] = expanduser("~/src/cmdstan-2.28.2/") # replace with your path
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
