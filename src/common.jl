const Bytes = Vector{UInt8}

const LITTLE_ENDIAN_BOM = 0x04030201
const BIG_ENDIAN_BOM = 0x01020304
const SRID_FLAG = UInt32(0x20)

@enum Endian BigEndian=0x00 LittleEndian=0x01
