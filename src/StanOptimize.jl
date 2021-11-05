"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanOptimize

using Parameters, StanDump
#using DataFrames

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

using StanBase

import StanBase: update_model_file, par, handle_keywords!
import StanBase: executable_path, ensure_executable, stan_compile

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
