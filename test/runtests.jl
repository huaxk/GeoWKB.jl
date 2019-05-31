using Test

@testset "GeoWKB" begin
    include(joinpath(@__DIR__, "sampledata.jl"))
    include(joinpath(@__DIR__, "test_wkb.jl"))
end
