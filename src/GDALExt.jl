module GDALExt

export fromEWKB, toEWKB

using GDAL
using ArchGDAL: fromWKB, toWKB, getspatialref, setspatialref!, getattrvalue, importEPSG,
    OGRwkbByteOrder, AbstractGeometry, AbstractSpatialRef
using ArchGDAL; const AG = ArchGDAL

include("common.jl")

getendian(data::Bytes) = Endian(data[1])

function sameendian(endian::Endian)
    if ENDIAN_BOM == LITTLE_ENDIAN_BOM && endian == LittleEndian
        true
    elseif ENDIAN_BOM == BIG_ENDIAN_BOM && endian == BigEndian
        true
    else
        false
    end
end

"""
Create a geometry object of the appropriate type from it's well known
binary (WKB) representation.

### Parameters
* `data`: pointer to the input BLOB data.
* `spatialref`: handle to the spatial reference to be assigned to the created
    geometry object. This may be `NULL` (default).
"""
function fromEWKB(data::Bytes)
    srid, data = extractsrid(data)
    if srid == nothing
        geom = fromWKB(data)
    else
        ref = importEPSG(srid)
        # geom = fromWKB(data, ref)
        geom = fromWKB(data)
        setspatialref!(geom, AG.SpatialRef(ref.ptr))
    end
    geom
end

function hassrid(data::Bytes)
    endian = getendian(data)
    pos = sameendian(endian) ? 5 : 2
    return data[pos] == SRID_FLAG
end

function removesridflag!(header::Bytes, endian::Endian=LittleEndian)
    pos = sameendian(endian) ? 5 : 2
    header[pos] = 0x00
    header
end

function extractsrid(data::Bytes)
    srid = nothing
    endian = getendian(data)
    if hassrid(data)
        srid = bytes2srid(data[6:9], endian)
        header = removesridflag!(data[1:5], endian)
        data = vcat(header, data[10:end])
    end
    srid, data
end

"""
Convert a geometry extended well known binary format.

### Parameters
* `geom`: handle on the geometry to convert to a well know binary data from.
* `endian`: One of BigEndian or [LittleEndian] indicating MSB or LSB byte order resp.
"""
function toEWKB(geom::AbstractGeometry, endian::Endian=LittleEndian)
    buffer = toWKB(geom, GDAL.OGRwkbByteOrder(UInt8(endian)))
    srid = geom |> getspatialref |> getsrid
    if srid != nothing
        endian = getendian(buffer)
        header = setsridflag!(buffer[1:5], endian)
        sridbytes = srid2bytes(srid, endian)
        buffer = vcat(header, sridbytes, buffer[6:end])
    end
    buffer
end

function getsrid(ref::AbstractSpatialRef)
    srid = nothing
    if ref.ptr != C_NULL
        epsgstr = getattrvalue(ref, "AUTHORITY", 0)
        sridstr = getattrvalue(ref, "AUTHORITY", 1)
        if epsgstr != nothing && sridstr != nothing && uppercase(epsgstr) == "EPSG"
            srid = parse(UInt32, sridstr)
        end
    end
    srid
end

function srid2bytes(srid::UInt32, endian::Endian=LittleEndian)
    srid = sameendian(endian) ? srid : bswap(srid)
    io = IOBuffer()
    Base.write(io, srid)
    take!(io)
end

function bytes2srid(sriddata::Bytes, endian::Endian=LittleEndian)
    io = IOBuffer(sriddata)
    srid = Base.read(io, UInt32)
    sameendian(endian) ? srid : bswap(srid)
end

function setsridflag!(header::Bytes, endian::Endian=LittleEndian)
    # length(header) < 5 && @error "wkb format error"
    pos = sameendian(endian) ? 5 : 2
    header[pos] = SRID_FLAG
    header
end

end  # module GDALExt
