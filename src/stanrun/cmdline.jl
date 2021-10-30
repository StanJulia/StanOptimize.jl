"""

# cmdline 

Recursively parse the model to construct command line. 

### Method
```julia
cmdline(m)
```

### Required arguments
```julia
* `m::CmdStanModel`                    : CmdStanSampleModel
```

### Related help
```julia
?OptimizeModel                         : Create a OptimizeModel
?stan_optimize                         : Execute an OptimizeModel
```
"""
function cmdline(m::OptimizeModel, id)
  
    #=
    `/Users/rob/.julia/dev/StanOptimize/examples/Bernoulli/tmp/bernoulli
    optimize 
    algorithm=lbfgs init_alpha=0.001 tol_obj=1.0e-8 tol_rel_
    obj=10000.0 tol_grad=1.0e-8 tol_rel_grad=1.0e7 tol_param=1.0e-8 
    history_size=5 iter=2000 save_iterations=1 random seed=-1 init=2 
    id=1 data file=/Users/rob/.julia/dev/StanOptimize/examples/Bernoulli/tmp/bernoulli_data_1.R 
    output file=/Users/rob/.julia/dev/StanOptimize/examples/Bernoulli/tmp/bernoulli_chain_1.csv 
    refresh=100`
    =#

    cmd = ``
    if isa(m, OptimizeModel)
        # Handle the model name field for unix and windows
        cmd = `$(m.exec_path)`

        # Sample() specific portion of the model
        cmd = `$cmd optimize`

        cmd = `$cmd algorithm=$(m.algorithm)`
        if m.algorithm in [:lbfgs, :bfgs]
            cmd = `$cmd init_alpha=$(m.init_alpha)`
            cmd = `$cmd tol_obj=$(m.tol_obj)`
            cmd = `$cmd tol_rel_obj=$(m.tol_rel_obj)`
            cmd = `$cmd tol_grad=$(m.tol_grad)`
            cmd = `$cmd tol_rel_grad=$(m.tol_rel_grad)`
            cmd = `$cmd tol_param=$(m.tol_param)`
            if m.algorithm == :lbfgs
                cmd = `$cmd history_size=$(m.history_size)`
            end
        elseif m.algorithn == :newtom
            cmd = `$cmd iter=$(m.iter)`
            if m.save_history
                cmd = `$cmd save_iterations=1`
            else
                cmd = `$cmd save_iterations=0`
            end
        end

        # Common to all models
        cmd = `$cmd random seed=$(m.seed)`

        # Init file required?
        if length(m.init_file) > 0 && isfile(m.init_file[id])
          cmd = `$cmd init=$(m.init_file[id])`
        else
          cmd = `$cmd init=$(m.init)`
        end

        # Data file required?
        if length(m.data_file) > 0 && isfile(m.data_file[id])
          cmd = `$cmd id=$(id) data file=$(m.data_file[id])`
        end

        # Output options
        cmd = `$cmd output`
        if length(m.sample_file) > 0
          cmd = `$cmd file=$(m.sample_file[id])`
        end
        if length(m.diagnostic_file) > 0
          cmd = `$cmd diagnostic_file=$(m.diagnostic_file[id])`
        end

        cmd = `$cmd refresh=$(m.refresh)`
    end
    cmd
end
