module GDALExt

using GDAL
using ArchGDAL: toWKB, getspatialref, getattrvalue,
    OGRwkbByteOrder, AbstractGeometry, AbstractSpatialRef

include("common.jl")

export toEWKB

getendian(data::Bytes) = Endian(data[1])

"""
Convert a geometry extended well known binary format.

### Parameters
* `geom`: handle on the geometry to convert to a well know binary data from.
* `order`: One of wkbXDR or [wkbNDR] indicating MSB or LSB byte order resp.
"""
function toEWKB(geom::AbstractGeometry, order::OGRwkbByteOrder=GDAL.wkbNDR)
    buffer = toWKB(geom, order)
    ref = getspatialref(geom)
    srid = getsrid(ref)
    if srid != nothing
        sridbytes = srid2bytes(srid)
        buffer = vcat(setsridflag!(buffer[1:5]), sridbytes, buffer[6:end])
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

function samebyteorder(order::OGRwkbByteOrder)
    if ENDIAN_BOM == 0x04030201 && order == GDAL.wkbNDR
        true
    elseif ENDIAN_BOM == 0x01020304 && order == GDAL.wkbXDR
        true
    else
        false
    end
end

function srid2bytes(srid::UInt32, order::OGRwkbByteOrder=GDAL.wkbNDR)
    srid = samebyteorder(order) ? srid : bswap(srid)
    io = IOBuffer()
    Base.write(io, srid)
    take!(io)
end

function setsridflag!(bytes::Vector{UInt8}, order::OGRwkbByteOrder=GDAL.wkbNDR)
    length(bytes) < 5 && @error "wkb format error"
    pos = samebyteorder(order) ? 5 : 2
    bytes[pos] = 0x20
    # if bytes[1] == 0x01 #在大端机器上，这样判断和设置字节序有没有问题？
    #     bytes[5] = 0x20
    # elseif bytes[1] == 0x00
    #     bytes[2] == 0x20
    # else
    #     @error "endian format error"
    # end
    bytes
end

end  # module GDALExt
