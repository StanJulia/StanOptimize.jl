######### CmdStan optimize example  ###########

using StanOptimize

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

bernoulli_data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

stanmodel = CmdStanOptimizeModel("bernoulli",  bernoulli_model;
  tmpdir = joinpath(@__DIR__, "tmp"));

(sample_path, log_path) = stan_sample(stanmodel, data=bernoulli_data);

if sample_path !== Nothing
  optim, cnames = read_optimize(stanmodel)
  println()
  display(optim)
  println()
end

# Same with saved iterations
stanmodel = CmdStanOptimizeModel("bernoulli", bernoulli_model;
  method = StanOptimize.Optimize(save_iterations = true),
  tmpdir = joinpath(@__DIR__, "tmp"));

(sample_path, log_path)  = stan_sample(stanmodel, data=bernoulli_data);

if sample_path !== Nothing
  optim, cnames = read_optimize(stanmodel)
  println()
  display(optim)
  println()
end

