using Base:GenericIOBuffer
import Base.read

include("./typemaps.jl")

const BIG_ENDIAN = 0x00
const LITTLE_ENDIAN = 0x01
const SRID_FLAG = 0x20

function sameendinan(flag::UInt8)
    if BIG_ENDIAN == flag && ENDIAN_BOM == 0x01020304
        true
    elseif LITTLE_ENDIAN == flag && ENDIAN_BOM == 0x04030201
        true
    elseif flag in (BIG_ENDIAN, LITTLE_ENDIAN)
        false
    else
        error("seriously? what is this wkb format?")
    end
end

"""
    WKB Type
"""
struct WKB
    data::AbstractVector{UInt8}
end

function WKB(s::AbstractString; hex=false)
    hex ? WKB(hex2bytes(s)) : WKB(Vector{UInt8}(s))
end

macro WKB_str(s)
    WKB(s)
end

macro HEXWKB_str(s)
    WKB(s; hex=true)
end

IOBuffer(wkb::WKB) = Base.IOBuffer(wkb.data)

read(s::IO, T, swap=false) = swap ? read(s, T) |> bswap : read(s, T)

# struct Geometry
# end

"""
    read(WKB)
"""
# function read(s::AbstractString, ::Type{NamedTuple}; hex=false)
#     wkb = WKB(s, hex=hex)
#     read(wkb)
# end

# function read(s::AbstractString, ::Type{Geometry}; hex=false)
#     wkb = WKB(s, hex=hex)
#     geo = read(wkb)
#     expr = :(($(geo.type))($(geo.coordinates)))
#     eval(expr)
# end

function read(b::WKB; withsrid=true, zipmulti=true)
    wkbio = IOBuffer(b)
    _read(wkbio, withsrid=withsrid, zipmulti=zipmulti)
end

function _read(data::GenericIOBuffer; withsrid=true, onlydata=false, zipmulti=true)
    endian = read(data, UInt8)
    srid = nothing
    same = sameendinan(endian)

    typefield = read(data, UInt32, !same)
    typecode = typefield & 0x00ffffff
    geotype = BINARY_TO_GEOM_TYPE[typecode] |> string
    hassrid = (typefield & 0xff000000) >>> 24 == SRID_FLAG
    if hassrid
        srid = read(data, UInt32, !same)
    end

    if startswith(geotype, "Multi")
        coords = _load(WKBCode(typecode), data, swap=!same, onlydata=zipmulti)
    else
        coords = _load(WKBCode(typecode), data, swap=!same)
    end

    if onlydata
        coords
    elseif hassrid && withsrid
        if geotype == "GeometryCollection"
            (type=geotype, geometries=coords,
             meta=(srid=srid,),
             crs=(type="name", properties=(name="EPSG$srid",)))
        else
            (type=geotype, coordinates=coords,
             meta=(srid=srid,),
             crs=(type="name", properties=(name="EPSG$srid",)))
        end
    else
        if geotype == "GeometryCollection"
            (type=geotype, geometries=coords)
        else
            (type=geotype, coordinates=coords)
        end
    end
end

"""
    readcoords(data::GenericIOBuffer, n=2, swap=false)
    n坐标的维度
"""
function readcoords(data::GenericIOBuffer; nb=2, swap=false)
    [read(data, Float64, swap) for i in 1:nb]
end

function readnodes(data::GenericIOBuffer; nb=2, swap=false)
    node = read(data, UInt32, swap)
    [readcoords(data, nb=nb, swap=swap) for i in 1:node]
end

function readrings(data::GenericIOBuffer; nb=2, swap=false)
    ring = read(data, UInt32, swap)
    [readnodes(data, nb=nb, swap=swap) for i in 1:ring]
end

function readmulti(data::GenericIOBuffer; swap=false, onlydata=true)
    num = read(data, UInt32, swap)
    [_read(data; onlydata=onlydata) for i in 1:num]
end

function readgc(data::GenericIOBuffer; swap=false, onlydata=false)
    num = read(data, UInt32, swap)
    [_read(data; onlydata=onlydata) for i in 1:num]
end

"""
根据WKB type code值派发
"""
struct WKBCode{x}
end

WKBCode(x) = (Base.@_pure_meta; WKBCode{x}())

function _load(::WKBCode{WKB_2D[:Point]}, data::GenericIOBuffer; swap=false)
    readcoords(data, swap=swap)
end

function _load(::WKBCode{WKB_Z[:Point]}, data::GenericIOBuffer; swap=false)
    readcoords(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_M[:Point]}, data::GenericIOBuffer; swap=false)
    readcoords(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_ZM[:Point]}, data::GenericIOBuffer; swap=false)
    readcoords(data, nb=4, swap=swap)
end

function _load(::WKBCode{WKB_2D[:LineString]}, data::GenericIOBuffer; swap=false)
    readnodes(data, swap=swap)
end

function _load(::WKBCode{WKB_Z[:LineString]}, data::GenericIOBuffer; swap=false)
    readnodes(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_M[:LineString]}, data::GenericIOBuffer; swap=false)
    readnodes(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_ZM[:LineString]}, data::GenericIOBuffer; swap=false)
    readnodes(data, nb=4, swap=swap)
end

function _load(::WKBCode{WKB_2D[:Polygon]}, data::GenericIOBuffer; swap=false)
    readrings(data, swap=swap)
end

function _load(::WKBCode{WKB_Z[:Polygon]}, data::GenericIOBuffer; swap=false)
    readrings(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_M[:Polygon]}, data::GenericIOBuffer; swap=false)
    readrings(data, nb=3, swap=swap)
end

function _load(::WKBCode{WKB_ZM[:Polygon]}, data::GenericIOBuffer; swap=false)
    readrings(data, nb=4, swap=swap)
end

function _load(::WKBCode{WKB_2D[:MultiPoint]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_Z[:MultiPoint]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_M[:MultiPoint]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_ZM[:MultiPoint]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_2D[:MultiLineString]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_Z[:MultiLineString]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_M[:MultiLineString]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_ZM[:MultiLineString]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_2D[:MultiPolygon]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_Z[:MultiPolygon]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_M[:MultiPolygon]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_ZM[:MultiPolygon]}, data::GenericIOBuffer; swap=false, onlydata=true)
    readmulti(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_2D[:GeometryCollection]}, data::GenericIOBuffer; swap=false, onlydata=false)
    readgc(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_Z[:GeometryCollection]}, data::GenericIOBuffer; swap=false, onlydata=false)
    readgc(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_M[:GeometryCollection]}, data::GenericIOBuffer; swap=false, onlydata=false)
    readgc(data; swap=swap, onlydata=onlydata)
end

function _load(::WKBCode{WKB_ZM[:GeometryCollection]}, data::GenericIOBuffer; swap=false, onlydata=false)
    readgc(data; swap=swap, onlydata=onlydata)
end
