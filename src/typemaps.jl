const WKB_2D = Dict{Symbol,UInt32}(
    :Point=>1,
    :LineString=>2,
    :Polygon=>3,
    :MultiPoint=>4,
    :MultiLineString=>5,
    :MultiPolygon=>6,
    :GeometryCollection=>7,
)

const WKB_Z = Dict{Symbol,UInt32}(
    :Point=>1001,
    :LineString=>1002,
    :Polygon=>1003,
    :MultiPoint=>1004,
    :MultiLineString=>1005,
    :MultiPolygon=>1006,
    :GeometryCollection=>1007,
)

const WKB_M = Dict{Symbol,UInt32}(
    :Point=>2001,
    :LineString=>2002,
    :Polygon=>2003,
    :MultiPoint=>2004,
    :MultiLineString=>2005,
    :MultiPolygon=>2006,
    :GeometryCollection=>2007,
)

const WKB_ZM = Dict{Symbol,UInt32}(
    :Point=>3001,
    :LineString=>3002,
    :Polygon=>3003,
    :MultiPoint=>3004,
    :MultiLineString=>3005,
    :MultiPolygon=>3006,
    :GeometryCollection=>3007,
)

const _WKB = Dict(
    "2D"=> WKB_2D,
    "Z"=> WKB_Z,
    "M"=> WKB_M,
    "ZM"=> WKB_ZM
)

const BINARY_TO_GEOM_TYPE = begin
    d = Dict{UInt32, Symbol}()
    for wkb_map in values(_WKB)
        for k in keys(wkb_map)
            d[wkb_map[k]] = k
        end
    end
    d
end

INT_TO_DIM_LABEL = Dict(2=> "2D", 3=> "Z", 4=> "ZM")
