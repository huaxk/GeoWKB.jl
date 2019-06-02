using Test
using GeoInterface: AbstractGeometry

include(joinpath(@__DIR__, "../src/register.jl"))

@testset "Register new type" begin
    conn = LibPQ.Connection("dbname=gis user=gis password=gispass"; throw_error=false)
    oid = getTypeOid(conn, :geometry)
    @test oid != nothing
    # @test LibPQ.registerType(:geometry, oid, AbstractGeometry)
end
