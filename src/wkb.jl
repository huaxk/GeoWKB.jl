using Base:GenericIOBuffer
import Base:read, write

include("./typemaps.jl")
include("./utils.jl")

const SRID_FLAG = UInt32(0x20)

@enum Endian BigEndian=0x00 LittleEndian=0x01

function sameendinan(flag::UInt8)
    if ENDIAN_BOM == 0x01020304 && Endian(flag) == BigEndian
        true
    elseif ENDIAN_BOM == 0x04030201 && Endian(flag) == LittleEndian
        true
    else
        false
    end
end

function sameendinan(endian::Endian)
    if ENDIAN_BOM == 0x01020304 && endian == BigEndian
        true
    elseif ENDIAN_BOM == 0x04030201 && endian == LittleEndian
        true
    else
        false
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

read(s::IO, T; swap=false) = swap ? read(s, T) |> bswap : read(s, T)
write(s::IO, T; swap=false) = swap ? write(s, T |> bswap) : write(s, T)

"""
    read(WKB)
"""
function read(b::WKB; withsrid=true, zipmulti=true)
    wkbio = IOBuffer(b)
    _read(wkbio, withsrid=withsrid, zipmulti=zipmulti)
end

function write(geo::NamedTuple; endian=LittleEndian, hex=false)
    fields = keys(geo)
    if :type in fields
        geotype = geo.type
    else
        error("Geometry object must have type fields?")
    end

    if :coordinates in fields
        coords_or_geoms = geo.coordinates
    elseif :geometries in fields
        coords_or_geoms = geo.geometries
    else
        error("Geometry object must have coordinates or geometries fields?")
    end

    meta = :meta in fields ? geo.meta : nothing
    srid = meta != nothing && :srid in keys(meta) ? meta.srid : nothing

    io = Base.IOBuffer()
    io = _write(io, endian=endian)
    bytes = take!(io)
    hex ? String(bytes2hex(bytes)) : String(bytes)
end

function _write(io::GenericIOBuffer, endian::Endian, typecode::UInt32, srid::UInt32=nothing)
    write(io, endian |> UInt8)
    swap = !sameendinan(endian)

    if srid != nothing
        typefield = (typecode) | bswap(SRID_FLAG)
        write(typecode, swap=swap)
        write(srid, swap=swap)
    else
        typefield = typecode
        write(typecode, swap=swap)
    end
end

function _read(io::GenericIOBuffer; withsrid=true, onlydata=false, zipmulti=true)
    endian = read(io, UInt8)
    srid = nothing
    same = sameendinan(endian)

    typefield = read(io, UInt32, swap=!same)
    typecode = typefield & 0x00ffffff
    geotype = BINARY_TO_GEOM_TYPE[typecode] |> string
    hassrid = (typefield & 0xff000000) |> bswap == SRID_FLAG
    if hassrid
        srid = read(io, UInt32, swap=!same)
    end

    if startswith(geotype, "Multi")
        coords = _load(WKBCode(typecode), io, swap=!same, onlydata=zipmulti)
    else
        coords = _load(WKBCode(typecode), io, swap=!same)
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
function readcoords(io::GenericIOBuffer; nb=2, swap=false)
    [read(io, Float64, swap=swap) for i in 1:nb]
end

function writecoords(io::GenericIOBuffer, data::Vector{Float64}; swap=false)
    nb = length(data)
    for i in 1:nb
        write(io, data[i], swap=swap)
    end
end

function readnodes(io::GenericIOBuffer; nb=2, swap=false)
    node = read(io, UInt32, swap=swap)
    [readcoords(io, nb=nb, swap=swap) for i in 1:node]
end

function writenodes(io::GenericIOBuffer, data::Vector{Vector{Float64}}; swap=false)
    node = length(data) |> UInt32
    write(io, node, swap=swap)
    for i in 1:node
        writecoords(io, data[i], swap=swap)
    end
end

function readrings(io::GenericIOBuffer; nb=2, swap=false)
    ring = read(io, UInt32, swap=swap)
    [readnodes(io, nb=nb, swap=swap) for i in 1:ring]
end

function writerings(io::GenericIOBuffer, data::Vector{Vector{Vector{Float64}}}; swap=false)
    ring = length(data) |> UInt32
    write(io, ring, swap=swap)
    for i in 1:ring
        writenodes(io, data[i], swap=swap)
    end
end

function readmulti(io::GenericIOBuffer; swap=false, onlydata=true)
    num = read(io, UInt32, swap=swap)
    [_read(io; onlydata=onlydata) for i in 1:num]
end

function writemulti(io::GenericIOBuffer, data::Vector{Vector{Vector{Vector{Float64}}}}; swap=false)
    num = length(data) |> UInt32
    write(io, num, swap=swap)

end

function readgc(io::GenericIOBuffer; swap=false, onlydata=false)
    num = read(io, UInt32, swap=swap)
    [_read(io; onlydata=onlydata) for i in 1:num]
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
