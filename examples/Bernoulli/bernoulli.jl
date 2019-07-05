######### CmdStan optimize example  ###########

using StanOptimize, Test, Statistics

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

bernoulli_data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]

tmpdir = joinpath(ProjDir, "tmp")

stanmodel = CmdStanOptimizeModel("bernoulli",  bernoulli_model);

rc, optim, cnames = stan(stanmodel, data=bernoullidata);

if rc == 0
  optim, cnames = read_optimize(model)
  println()
  display(optim)
  println()
  @test optim["theta"][end] ≈ 0.3 atol=0.1
end

# Same with saved iterations
stanmodel = CmdStanOptimizeModel(name = "bernoulli", model = bernoulli,
  method = Optimize(save_iterations = true));

rc, optim, cnames = stan(stanmodel, data=bernoullidata);

if rc == 0
  optim, cnames = read_optimize(model)
  println()
  display(optim)
  println()
  @test optim["theta"][end] ≈ 0.3 atol=0.1
end

