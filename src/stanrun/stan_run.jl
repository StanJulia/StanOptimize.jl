
"""

`stan_optimize(...)`

Optimize a StanJulia OptimizationModel <: CmdStanModel

# Extended help

### Dispatch arguments
```julia
* `m:: OptimizeModel`             # CmdStanModel subtype
* `use_json=true`                 # Use JSON3 for data and init files
```

### Keyword arguments
```julia
* `init`                               : Init dict
* `data`                               : Data dict
```
$(SIGNATURES)

### Returns
```julia
* `rc`                                 # Return code, 0 is success.
```

See extended help for other keyword arguments ( `??stan_optimize` ).

# Extended help

### Additional configuration keyword arguments
```julia
* `num_chains=4`                       # Update number of chains.
* `num_threads=8`                      # Update number of threads.

* `seed=-1`                            # Set seed value.
* `init_bound=2`                       # Boundary for initialization
* `refresh=200`                        # Stream to output

* `algorithm=:lbfgs`                   # Algorithms: :lbfgs, bfgs or :newton.
* `init_alpha=0.0001`                  # Line search step size first iteration.
* `tol_obj=9.999e-13`                  # Convergence tolerance
* `tol_rel_obj=9.999e-13`              # Relative convergence tolerance
* `tol_grad=9.999e-13`                 # Convergence tolerance on norm of gradient
* `tol_rel_grad=9.999e-13`             # Relative convergence tolerance
* `tol_param=1e-8`                     # Convergence tolerance on param changes

* `history_size=`                      # Amount of history to keep for L-BFGS

* `iter=200`                           # Total number of Newton iterations
* `save_iterations=0`                  # Stream iterations to output
```
"""
function stan_run(m::T, use_json=true; kwargs...) where {T <: CmdStanModels}

    handle_keywords!(m, kwargs)

    # Remove existing sample files
    for id in 1:m.num_chains
        sfile = sample_file_path(m.output_base, id)
        isfile(sfile) && rm(sfile)
    end

    if use_json
        :init in keys(kwargs) && update_json_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_json_files(m, kwargs[:data],
            m.num_chains, "data")
    else
        :init in keys(kwargs) && update_R_files(m, kwargs[:init],
            m.num_chains, "init")
        :data in keys(kwargs) && update_R_files(m, kwargs[:data],
            m.num_chains, "data")
    end

    m.cmds = [stan_cmds(m, id; kwargs...) for id in 1:m.num_chains]

    #println(typeof(m.cmds))
    #println()
    #println(m.cmds)

    run(pipeline(par(m.cmds), stdout=m.log_file[1]))
end

"""

Generate a cmdstan command line (a run `cmd`).

$(SIGNATURES)

Internal, not exported.
"""
function stan_cmds(m::T, id::Integer; kwargs...) where {T <: CmdStanModels}
    append!(m.sample_file, [sample_file_path(m.output_base, id)])
    append!(m.log_file, [log_file_path(m.output_base, id)])
    if length(m.diagnostic_file) > 0
      append!(m.diagnostic_file, [diagnostic_file_path(m.output_base, id)])
    end
    cmdline(m, id)
end
