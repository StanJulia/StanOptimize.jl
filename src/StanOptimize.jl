"""
Helper infrastructure to compile and sample models using `cmdstan`.

[`StanModel`](@ref) wraps a model definition (source code), while [`stan_sample`](@ref) can
be used to sample from it.

[`stan_compile`](@ref) can be used to pre-compile a model without sampling. A
[`StanModelError`](@ref) is thrown if this fails, which contains the error messages from
`stanc`.
"""
module StanOptimize

using StanBase
using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

import StanBase: stan_sample, get_cmdstan_home
import StanBase: cmdline

include("stanmodel/optimize_types.jl")
include("stanmodel/OptimizeModel.jl")
include("stanrun/cmdline.jl")
include("stansamples/read_optimize.jl")

stan_optimize = stan_sample

export
  OptimizeModel,
  stan_optimize,
  read_optimize

end # module
