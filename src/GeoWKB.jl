module GeoWKB

include("GDALExt.jl")
include("LibPQExt.jl")
using .GDALExt
using .LibPQEx

export register, fromEWKB, toEWKB

end # module
