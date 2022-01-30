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

data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])
init = (theta = .5,)
tmpdir = joinpath(@__DIR__, "tmp")

stanmodel = OptimizeModel("bernoulli",  bernoulli_model, tmpdir);
rc = stan_optimize(stanmodel; num_chains=4, data, init);

if success(rc)
  optim1, cnames = read_optimize(stanmodel)
  println()
  display(optim1)
  println()
end

# Same with saved iterations
stanmodel = OptimizeModel("bernoulli", bernoulli_model);

rc2  = stan_optimize(stanmodel; data, save_iterations=true);

if success(rc2)
  optim2, cnames = read_optimize(stanmodel)
  println()
  display(optim2)
  println()
end
