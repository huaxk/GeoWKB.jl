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

@testset "sameendian" begin
    @test GE.sameendian(GE.LittleEndian) == true
    @test GE.sameendian(GE.BigEndian) == false
end

@testset "srid2bytes" begin
    srid = UInt32(4326)
    @test GE.srid2bytes(srid) == Bytes("\xe6\x10\x00\x00")
    @test GE.srid2bytes(srid, GE.BigEndian) == Bytes("\x00\x00\x10\xe6")
end

@testset "setsridflag!" begin
    typebytes = Bytes("\x01\x01\x00\x00\x00")
    @test GE.setsridflag!(typebytes) == Bytes("\x01\x01\x00\x00\x20")
end

@testset "toWKB" begin
    pt = AG.fromWKT(pt2d_wkt)
    @test GE.toEWKB(pt) == Bytes(pt2d_wkb)
    iref = AG.importEPSG(4326)
    ref =  AG.SpatialRef(iref.ptr)
    AG.setspatialref!(pt, ref)
    @test GE.toEWKB(pt) == Bytes(pt2d_srid4326_wkb)

    ls = AG.fromWKT(ls2d_wkt)
    @test GE.toEWKB(ls, GE.BigEndian) == Bytes(ls2d_wkb)
    iref = AG.importEPSG(4326)
    ref =  AG.SpatialRef(iref.ptr)
    AG.setspatialref!(ls, ref)
    @test GE.toEWKB(ls, GE.BigEndian) == Bytes(ls2d_srid4326_wkb)

    pg = AG.fromWKT(pg2d_wkt)
    @test GE.toEWKB(pg, GE.BigEndian) == Bytes(pg2d_wkb)
    iref = AG.importEPSG(26918)
    ref =  AG.SpatialRef(iref.ptr)
    AG.setspatialref!(pg, ref)
    @test GE.toEWKB(pg, GE.BigEndian) == Bytes(pg2d_srid26918_wkb)
end

end
