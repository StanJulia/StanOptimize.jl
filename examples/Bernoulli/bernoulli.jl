######### CmdStan optimize example  ###########

using StanOptimize

ProjDir = @__DIR__
cd(ProjDir) do

  bernoulli_model = "
  data { 
    int<lower=1> N; 
    int<lower=0,upper=1> y[N];
  } 
  parameters {
    real<lower=0,upper=1> theta;
  } 
  model {
    theta ~ beta(1,1);
    y ~ bernoulli(theta);
  }
  ";

  bernoulli_data = [
    Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 0, 0, 0, 1, 0, 1, 1]),
    Dict("N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1])
  ]

  tmpdir = joinpath(ProjDir, "tmp")
  global stanmodel = CmdStanModel("bernoulli",  bernoulli_model, tmpdir=tmpdir);
  #global stanmodel = CmdStanModel("bernoulli",  bernoulli_model);
 
  update_settings(stanmodel, (delta=0.85,))
  
  println()
  @show stan_optimize(stanmodel.sm, bernoulli_data, 4)  
  println()
  
  a3d, cnames = read_stanrun_samples(stanmodel.output_base, "_chain")
  global chns = convert_a3d(a3d, cnames, Val(:mcmcchains); start=1)
  cdf = describe(chns)
  
end # cd
