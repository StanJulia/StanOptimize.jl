"""

$(SIGNATURES)

Helper infrastructure to compile and sample models using `cmdstan`.

"""
module StanOptimize

using Reexport

using Parameters, NamedTupleTools
using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF

@reexport using StanBase

import StanBase: update_model_file, par, handle_keywords!
import StanBase: executable_path, ensure_executable, stan_compile
import StanBase: update_json_files
import StanBase: data_file_path, init_file_path, sample_file_path
import StanBase: generated_quantities_file_path, log_file_path
import StanBase: diagnostic_file_path, setup_diagnostics

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
