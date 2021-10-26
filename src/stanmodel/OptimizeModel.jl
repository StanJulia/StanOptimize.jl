inport Base: show

mutable struct OptimizeModel <: CmdStanModels
  @shared_fields_stanmodels
  method::Optimize
end

"""
# OptimizeModel 

Create a OptimizeModel and compil Stan Language Model. 

### Required arguments
```julia
* `name::AbstractString`        : Name for the model
* `model::AbstractString`       : Stan model source
```

### Optional arguments
```julia
* `tmpdir=mktempdir()`          : Directory where output files are stored
```

"""
function OptimizeModel(name::AbstractString, model::AbstractString,
    tmpdir = mktempdir())
    
    !isdir(tmpdir) && mkdir(tmpdir)
    
    update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))

    output_base = joinpath(tmpdir, name)
    exec_path = StanBase.executable_path(output_base)
    cmdstan_home = get_cmdstan_home()

    error_output = IOBuffer()
    is_ok = cd(cmdstan_home) do
        success(pipeline(`make -f $(cmdstan_home)/makefile -C $(cmdstan_home) $(exec_path)`;
                         stderr = error_output))
    end

    if !is_ok
        throw(StanModelError(model, String(take!(error_output))))
    end

    OptimizeModel(name, model,
      # num_chains, num_threads, num_samples, num_warmups, save_warmups
      4, 4, 1000, 1000, false,
      # thin, seed, refresh, init_bound
      1, -1, 100, 2,
      # Adapt fields
      # engaged, gamma, delta, kappa, t0, init_buffer, term_buffer, window
      true, 0.05, 0.8, 0.75, 10, 75, 50, 25,
      # algorithm fields
      :hmc,                          # or :static
      # engine, max_depth
      :nuts, 10,
      # Static engine specific fields
      2pi,
      # metric, metric_file, stepsize, stepsize_jitter
      :diag_e, "", 1.0, 0.0,
      # Ouput settings
      #Output(),
      output_base,
      # Tmpdir settings
      tmpdir,
      # exec_path
      exec_path,
      # Data files
      AbstractString[],
      # Init files
      AbstractString[],  
      # Command lines
      Cmd[],
      # Sample .csv files  
      String[],
      # Log files
      String[],
      # Diagnostic files
      String[],
      # Create stansummary result
      true,
      # Display stansummary result
      false,
        cmdstan_home
end

function optimize_show(io::IO, m::OptimizeModel, compact::Bool)
  println(io, "  name =                    \"$(m.name)\"")
  println(io, "  n_chains =                $(StanBase.get_n_chains(m))")
  println(io, "  output =                  Output()")
  println(io, "    refresh =                 $(m.output.refresh)")
  println(io, "  tmpdir =                  \"$(m.tmpdir)\"")
  optimize_show(io, m.method, compact)
end

show(io::IO, m::OptimizeModel) = optimize_show(io, m, false)
