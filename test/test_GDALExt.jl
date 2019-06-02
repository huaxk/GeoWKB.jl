using Test
using GDAL
using ArchGDAL; const AG = ArchGDAL
using GeoInterface; const GI = GeoInterface

include(joinpath(@__DIR__, "sampledata.jl"))
include(joinpath(@__DIR__, "../src/GDALExt.jl"))
using .GDALExt; GE = GDALExt

@testset "GDALExt" begin

@testset "getendian" begin
    @test GE.getendian(Bytes("\x01\x01\x00\x00\x00")) == GE.LittleEndian
    @test GE.getendian(Bytes("\x00\x01\x00\x00\x00")) == GE.BigEndian
end

@testset "sameendian" begin
    @test GE.sameendian(GE.LittleEndian) == true
    @test GE.sameendian(GE.BigEndian) == false
end

@testset "hassrid" begin
    @test GE.hassrid(Bytes(pt2d_wkb)) == false
    @test GE.hassrid(Bytes(pt2d_srid4326_wkb)) == true
end

@testset "removesridflag" begin
    @test GE.removesridflag!(Bytes("\x01\x01\x00\x00\x20")) == Bytes("\x01\x01\x00\x00\x00")
end

@testset "extractsrid" begin
    pt2d_bytes = Bytes(pt2d_wkb)
    pt2d_srid4326_bytes = Bytes(pt2d_srid4326_wkb)
    @test GE.extractsrid(pt2d_bytes) == (nothing, pt2d_bytes)
    @test GE.extractsrid(pt2d_srid4326_bytes) == (UInt32(4326), pt2d_bytes)
end

@testset "getsrid" begin
    srid = 4326
    ref = AG.importEPSG(srid)
    @test GE.getsrid(ref) == srid
    ref_NULL = AG.SpatialRef(Ptr{GDAL.OGRSpatialReferenceH}(0))
    @test GE.getsrid(ref_NULL) == nothing
end

@testset "srid2bytes" begin
    srid = UInt32(4326)
    @test GE.srid2bytes(srid) == Bytes("\xe6\x10\x00\x00")
    @test GE.srid2bytes(srid, GE.BigEndian) == Bytes("\x00\x00\x10\xe6")
end

@testset "bytes2srid" begin
    srid = UInt32(4326)
    @test GE.bytes2srid(Bytes("\xe6\x10\x00\x00")) == srid
    @test GE.bytes2srid(Bytes("\x00\x00\x10\xe6"), GE.BigEndian) == srid
end

@testset "setsridflag!" begin
    @test GE.setsridflag!(Bytes("\x01\x01\x00\x00\x00")) == Bytes("\x01\x01\x00\x00\x20")
end

@testset "fromEWKB" begin
    pt = GE.fromEWKB(Bytes(pt2d_srid4326_wkb))
    @test AG.getspatialref(pt) |> GE.getsrid == UInt32(4326)
    @test GI.geotype(pt) == :Point
    @test GI.coordinates(pt) == pt2d_srid4326.coordinates

    ls = GE.fromEWKB(Bytes(ls2d_srid4326_wkb))
    @test AG.getspatialref(ls) |> GE.getsrid == UInt32(4326)
    @test GI.geotype(ls) == :LineString
    @test GI.coordinates(ls) == ls2d_srid4326.coordinates

    pg = GE.fromEWKB(Bytes(pg2d_srid26918_wkb))
    @test AG.getspatialref(pg) |> GE.getsrid == UInt32(26918)
    @test GI.geotype(pg) == :Polygon
    @test GI.coordinates(pg) == pg2d_srid26918.coordinates
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
