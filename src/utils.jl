function arraydeep(a::Array)
    deep = 1
    while eltype(a) <: Array
        deep += 1
        a = a[1]
    end
    deep
end
