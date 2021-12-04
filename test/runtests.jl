using StanOptimize, Test

if haskey(ENV, "JULIA_CMDSTAN_HOME") || haskey(ENV, "CMDSTAN")

    @testset "Bernoulli optimize" begin
      include(joinpath(@__DIR__, "../examples/Bernoulli/bernoulli.jl"))
      @test optim1["theta"][end] ≈ 0.3 atol=0.1
      @test optim2["theta"][end] ≈ 0.3 atol=0.1
    end

else
  println("\nJULIA_CMDSTAN_HOME and CMDSTAN not set. Skipping tests")
end
