"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanOptimize

using StanBase
using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF


include("stanmodel/OptimizeModel.jl")
include("stanrun/cmdline.jl")
include("stansamples/read_optimize.jl")

stan_optimize = stan_run

export
  OptimizeModel,
  stan_optimize,
  read_optimize

end # module
