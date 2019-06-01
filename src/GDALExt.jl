module GDALExt

using GDAL
using ArchGDAL: toWKB, getspatialref, getattrvalue,
    OGRwkbByteOrder, AbstractGeometry, AbstractSpatialRef

include("common.jl")

export toEWKB

"""
Convert a geometry extended well known binary format.

### Parameters
* `geom`: handle on the geometry to convert to a well know binary data from.
* `order`: One of wkbXDR or [wkbNDR] indicating MSB or LSB byte order resp.
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

getendian(data::Bytes) = Endian(data[1])

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

function sameendian(endian::Endian)
    if ENDIAN_BOM == LITTLE_ENDIAN_BOM && endian == LittleEndian
        true
    elseif ENDIAN_BOM == BIG_ENDIAN_BOM && endian == BigEndian
        true
    else
        false
    end
end

function srid2bytes(srid::UInt32, endian::Endian=LittleEndian)
    srid = sameendian(endian) ? srid : bswap(srid)
    io = IOBuffer()
    Base.write(io, srid)
    take!(io)
end

function setsridflag!(header::Bytes, endian::Endian=LittleEndian)
    length(header) < 5 && @error "wkb format error"
    pos = sameendian(endian) ? 5 : 2
    header[pos] = SRID_FLAG
    header
end



end  # module GDALExt
