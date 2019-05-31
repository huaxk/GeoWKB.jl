using Test
using GDAL
using ArchGDAL; const AG = ArchGDAL

include(joinpath(@__DIR__, "sampledata.jl"))
include(joinpath(@__DIR__, "../src/GDALExt.jl"))
using .GDALExt; GE = GDALExt

@testset "GDALExt" begin

@testset "getendian" begin
    @test GE.getendian(Bytes("\x01\x01\x00\x00\x00")) == GE.LittleEndian
    @test GE.getendian(Bytes("\x00\x01\x00\x00\x00")) == GE.BigEndian
end

@testset "getsrid" begin
    srid = 4326
    ref = AG.importEPSG(srid)
    @test GE.getsrid(ref) == srid
    ref_NULL = AG.SpatialRef(Ptr{GDAL.OGRSpatialReferenceH}(0))
    @test GE.getsrid(ref_NULL) == nothing
end

@testset "samebyteorder" begin
    @test GE.samebyteorder(GDAL.wkbNDR) == true
    @test GE.samebyteorder(GDAL.wkbXDR) == false
end

@testset "srid2bytes" begin
    srid = UInt32(4326)
    @test GE.srid2bytes(srid) == Vector{UInt8}("\xe6\x10\x00\x00")
    @test GE.srid2bytes(srid, GDAL.wkbXDR) == Vector{UInt8}("\x00\x00\x10\xe6")
end

@testset "setsridflag!" begin
    typebytes = Vector{UInt8}("\x01\x01\x00\x00\x00")
    @test GE.setsridflag!(typebytes) == Vector{UInt8}("\x01\x01\x00\x00\x20")
end

end
