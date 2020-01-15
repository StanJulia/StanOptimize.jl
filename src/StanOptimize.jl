"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanOptimize

using StanBase
using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

import StanBase: stan_sample, get_cmdstan_home
import StanBase: cmdline, stan_summary, read_summary
import StanBase: RandomSeed, Init, Output, StanModelError

include("stanmodel/optimize_types.jl")
include("stanmodel/OptimizeModel.jl")
include("stanrun/cmdline.jl")
include("stansamples/read_optimize.jl")

stan_optimize = stan_sample

export
  OptimizeModel,
  StanModelError,
  stan_optimize,
  read_optimize,
  read_summary,
  stan_summary

end # module
