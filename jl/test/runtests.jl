using Catio
using Test

@testset "Catio Tests" begin
    include.(["spec.jl","specavg.jl"])
end
