using Test

include(joinpath(@__DIR__, "sampledata.jl"))
include(joinpath(@__DIR__, "../src/wkb.jl"))

@testset "Point" begin
    @test read(pt2d_wkb) == pt2d
    @test read(ptz_wkb) == ptz
    @test read(ptm_wkb) == ptz
    @test read(ptzm_wkb) == ptzm
    @test read(pt2d_srid4326_wkb) == pt2d_srid4326
end

@testset "LineString" begin
    @test read(ls2d_wkb) == ls2d
    @test read(lsz_wkb) == lsz
    @test read(lsm_wkb) == lsz
    @test read(lszm_wkb) == lszm
    @test read(ls2d_srid1234_wkb) == ls2d_srid1234
end

@testset "Polygon" begin
    @test read(pg2d_wkb) == pg2d
    @test read(pgz_wkb) == pgz
    @test read(pgm_wkb) == pgz
    @test read(pgzm_wkb) == pgzm
    @test read(pg2d_srid26918_wkb) == pg2d_srid26918
end

@testset "MultiPoint" begin
    @test read(mpt2d_wkb) == mpt2d
    @test read(mptz_wkb) == mptz
    @test read(mptm_wkb) == mptz
    @test read(mptzm_wkb) == mptzm
    @test read(mpt2d_srid664_wkb) == mpt2d_srid664
end


@testset "MultiLineString" begin
    @test read(mls2d_wkb) == mls2d
    @test read(mlsz_wkb) == mlsz
    @test read(mlsm_wkb) == mlsz
    @test read(mlszm_wkb) == mlszm
    @test read(mls2d_srid4326_wkb) == mls2d_srid4326
end

@testset "MultiPolygon" begin
    @test read(mpg2d_wkb) == mpg2d
    @test read(mpgz_wkb) == mpgz
    @test read(mpgm_wkb) == mpgz
    @test read(mpgzm_wkb) == mpgzm
    @test read(mpg2d_srid4326_wkb) == mpg2d_srid4326
end

@testset "GeometryCollection" begin
    @test read(gc2d_wkb) == gc2d
    @test read(gcz_wkb) == gcz
    @test read(gcm_wkb) == gcz
    @test read(gczm_wkb) == gczm
    @test read(gc2d_srid1234_wkb) == gc2d_srid1234
end
