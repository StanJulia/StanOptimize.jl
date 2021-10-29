"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanOptimize

using Parameters

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

include("common/common_definitions.jl")
include("common/par.jl")
include("common/update_model_file.jl")

include("stanmodel/OptimizeModel.jl")

include("stanrun/cmdline.jl")
include("stanrun/stan_run.jl")

include("stansamples/read_optimize.jl")

stan_optimize = stan_run

export
  OptimizeModel,
  stan_optimize,
  read_optimize

end # module
