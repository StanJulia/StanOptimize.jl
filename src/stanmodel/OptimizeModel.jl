import Base: show

mutable struct OptimizeModel <: CmdStanModels
    name::AbstractString;              # Name of the Stan program
    model::AbstractString;             # Stan language model program
    num_chains::Int;                   # Number of chains
    num_threads::Int;                  # Number of threads
    seed::Int;                         # Seed section of cmd to run cmdstan
    init_bound::Int;                   # Bound for initial param values
    refresh::Int;                      # Rate to stream to output

    # Algorithm fields
    algorithm::Symbol;                 # :bfgs, :lbfgs or :newton (Default :lbfgs)

    # BFGS/L-BFGS specific fields
    init_alpha::Float64;               # Line search step size for first iteration
    tol_obj::Float64;                  # Convergence tolerance
    tol_rel_obj::Float64;              # Relative convergence tolerance
    tol_grad::Float64;                 # Convergence tolerance on norm of gradient
    tol_rel_grad::Float64;             # Relative convergence tolerance
    tol_param::Float64;                # Convergence tolerance on param changes

    # L-BFGS specific fields
    history_size::Int;                 # Amount of history to keep for L-BFGS

    # Newton
    iter::Int;                         # Total number of iterations
    save_iterations::Bool;             # Stream optimization progress to output

    # Output files
    output_base::AbstractString;       # Used for file paths to be created
    # Tmpdir setting
    tmpdir::AbstractString;            # Holds all created files
    # Cmdstan path
    exec_path::AbstractString;         # Path to the cmdstan excutable
    # Data and init file paths
    data_file::Vector{AbstractString}; # Array of data files input to cmdstan
    init_file::Vector{AbstractString}; # Array of init files input to cmdstan
    # Generated command line vector
    cmds::Vector{Cmd};                 # Array of cmds to be spawned/pipelined
    # Files created by cmdstan
    sample_file::Vector{String};       # Sample file array (.csv)
    log_file::Vector{String};          # Log file array
    diagnostic_file::Vector{String};   # Diagnostic file array
    # CMDSTAN_HOME
    cmdstan_home::AbstractString;      # Directory where cmdstan can be found
end

"""
# OptimizeModel 

Create an OptimizeModel and compile Stan Language Model. 

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
    exec_path = executable_path(output_base)
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
        4,                             # Number of chains
        8,                             # Number of threads
        -1,                            # seed
        2,                             # init_bound
        100,                           # refresh

        :lbfgs,                        # algorithm (:lbfgs, :bfgs or :newton)
        0.001,                         # init_alpha
        9.9999999999999998e-13,        # tol_obj
        10000.0,                       # tol_rel_obj
        1e-8,                          # tol_grad
        10000000.0,                    # tol_rel_grad
        1e-8,                          # tol_params 
        
        5,                             # history_size for L-BFGS
        
        2000,                          # Newton iterations
        false,                         # save_iterations

        output_base,                   # Output settings
        tmpdir,                        # Tmpdir settings
        exec_path,                     # exec_path
        AbstractString[],              # Data files
        AbstractString[],              # Init files 
        Cmd[],                         # Command lines
        String[],                      # Sample .csv files 
        String[],                      # Log files
        String[],                      # Diagnostic files
        cmdstan_home                   # Path to cmdstan binary
    )
end

function Base.show(io::IO, ::MIME"text/plain", m::OptimizeModel)
    println(io, "\nSample section:")
    println(io, "  name =                    ", m.name)
    println(io, "  num_chains =              ", m.num_chains)
    println(io, "  num_threads =             ", m.num_threads)
    println(io, "  seed =                    ", m.seed)
    println(io, "  init_bound =              ", m.init_bound)
    println(io, "  refresh =                 ", m.refresh)
    
    println(io, "\nAlgorithm section:")
    println(io, "  algorithm =               ", m.algorithm)
    if m.algorithm in [:lbfgs, :bfgs]
        println(io, "    init_alpha =              ", m.init_alpha)
        println(io, "    tol_obj =                 ", m.tol_obj)
        println(io, "    tol_rel_obj =             ", m.tol_rel_obj)
        println(io, "    tol_grad =                ", m.tol_grad)
        println(io, "    tol_rel_grad =            ", m.tol_rel_grad)
        println(io, "    tol_param =               ", m.tol_param)
        if m.algorithm == :lbfgs
            println(io, "    history_size =            ", m.history_size)
        end
    elseif m.algorithm == :newton
        println(io, "    iter =                    ", m.iter)
        println(io, "    save_iterations =         ", m.save_iterations)
    end
    
    println(io, "\nOther:")
    println(io, "  output_base =             ", m.output_base)
    println(io, "  tmpdir =                  ", m.tmpdir)
end
