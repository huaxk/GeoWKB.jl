const Bytes = Vector{UInt8}
const SRID_FLAG = UInt32(0x20)

@enum Endian BigEndian=0x00 LittleEndian=0x01
