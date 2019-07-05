using StanOptimize, Test

@testset "Bernoulli" begin
  include(joinpath(@__DIR__, "../examples/Bernoulli/bernoulli.jl"))
  @test optim["theta"][end] ≈ 0.3 atol=0.1
end

