struct CmdStanModel
  name::AbstractString
  model::AbstractString
  tmpdir::AbstractString
  output_base::AbstractString
  sm::StanRun.StanModel
  settings::StanSample.SamplerSettings
end

function CmdStanModel(name::AbstractString, model::AbstractString;
  tmpdir = mktempdir(), 
  settings = StanSample.sampler_settings)
  
  !isdir(tmpdir) && mkdir(tmpdir)
  update_model_file(joinpath(tmpdir, "$(name).stan"), strip(model))
  sm = StanModel(joinpath(tmpdir, "$(name).stan"))
  output_base = default_output_base(sm)
  stan_compile(sm)
  CmdStanModel(name, model, tmpdir, output_base, sm, settings)
end

function Base.show(io::IO, model::CmdStanModel)
    @unpack tmpdir, sm = model
    println(io, "Stan model at `$(tmpdir)`")
    println("`cmdstan` executable is at: $(sm.cmdstan_home))")
end

