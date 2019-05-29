using GeoInterface

@enum WKBByteOrder::UInt8 wkbXDR wkbNDR

const coDefaultByteOrder = wkbNDR

mutable struct WKBGeometryInfo
    byteOrder::WKBByteOrder
    wkbType::UInt32
end

mutable struct Point{T}
    x::T
    y::T
end

mutable struct LinearRing{T}
    numPoints::UInt32,
    points::Point{T}
end

mutable struct WKBPoint{T} <: GeoInterface.AbstractPoint
    wkbInfo::WKBGeometryInfo
    point::Point{T}
end

mutable struct WKBLineString{T} <: GeoInterface.AbstractLineString
    wkbInfo::WKBGeometryInfo
    numPoints::UInt32
    points::Vector{Point{T}}
end

mutable struct WKBPolygon{T} <: GeoInterface.AbstractPolygon
    wkbInfo::WKBGeometryInfo
    numRings::UInt32
    rings::Vector{LinearRing{T}}
end

mutable struct WKBMultiPoint{T}
    wkbInfo::WKBGeometryInfo
    numPoints::UInt32
    points::Vector{Point{T}}
end

mutable struct WKBMultiLineString{T}
    wkbInfo::WKBGeometryInfo
    numLineStrings::UInt32
    lineStrings::Vector{WKBLineString{T}}
end

mutable struct WKBMultiPolygon{T}
    wkbInfo::WKBGeometryInfo
    numPolygons::UInt32
    polygons::Vector{WKBPolygon{T}}
end

# WKBGeometry = Union{
#
# }
#
# mutable struct WKBGeometryCollection
#     wkbInfo::WKBGeometryInfo
#     numGeometries::UInt32
#     geometries::Vector{WKBGeometry}
# end

const WKBGeometryType = Dict{UInt32, Any}(
    0 => wkbNull,
    1 => wkbPoint,
    2 => wkbLineString,
    3 => wkbPolygon,
    4 => wkbMultiPoint,
    5 => wkbMultiLineString,
    6 => wkbMultiPolygon,
    7 => wkbGeometryCollection
)
