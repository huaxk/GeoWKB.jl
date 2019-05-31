include(joinpath(@__DIR__, "../src/wkb.jl"))

# Point =======================================================================
pt2d = (type="Point", coordinates=[0.0, 1.0])
pt2d_wkt = "Point(0.0 1.0)"
pt2d_wkb = WKB("\x01"*  # little endian
               "\x01\x00\x00\x00"*  # type
               "\x00\x00\x00\x00\x00\x00\x00\x00"*
               "\x00\x00\x00\x00\x00\x00\xf0?")
ptz = (type="Point", coordinates=[0.0, 1.0, 2.0])
ptz_wkb = WKB( "\x00"*  # big endian
               "\x00\x00\x03\xe9"*  # type
               "\x00\x00\x00\x00\x00\x00\x00\x00"*
               "?\xf0\x00\x00\x00\x00\x00\x00"*
               "@\x00\x00\x00\x00\x00\x00\x00")
ptm_wkb = WKB("\x00"*  # big endian
              "\x00\x00\x07\xd1"*  # type
              "\x00\x00\x00\x00\x00\x00\x00\x00"*
              "?\xf0\x00\x00\x00\x00\x00\x00"*
              "@\x00\x00\x00\x00\x00\x00\x00")
ptzm = (type="Point", coordinates=[0.0, 1.0, 2.0, 4.0])
ptzm_wkb = WKB("\x01"*  # little endian
               "\xb9\x0b\x00\x00"*  # type
               "\x00\x00\x00\x00\x00\x00\x00\x00"*
               "\x00\x00\x00\x00\x00\x00\xf0?"*
               "\x00\x00\x00\x00\x00\x00\x00@"*
               "\x00\x00\x00\x00\x00\x00\x10@")
pt2d_srid4326 = (type="Point", coordinates=[0.0, 1.0],
                 meta=(srid=4326,),
                 crs=(type="name", properties=(name="EPSG4326",)))
pt2d_srid4326_wkb = WKB("\x01"*  # little endian
                        "\x01\x00\x00\x20"*  # type, with SRID flag set (0x20)
                        "\xe6\x10\x00\x00"*  # SRID=4326
                        "\x00\x00\x00\x00\x00\x00\x00\x00"*
                        "\x00\x00\x00\x00\x00\x00\xf0?")

# LineString ==================================================================
ls2d = (type="LineString", coordinates=[[2.2, 4.4], [3.1, 5.1]])
ls2d_wkb = WKB("\x00"*  # big endian
               "\x00\x00\x00\x02"*  # type
               "\x00\x00\x00\x02"*  # 2 vertices
               "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
               "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
               "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
               "@\x14ffffff") # 5.1
lsz = (type="LineString", coordinates=[[2.2, 4.4, 10.0],[3.1, 5.1, 20.0]])
lsz_wkb = WKB("\x01"*  # little endian
              "\xea\x03\x00\x00"*  # type
              "\x02\x00\x00\x00"*  # 2 vertices
              "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
              "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
              "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
              "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
              "ffffff\x14@"*                   # 5.1
              "\x00\x00\x00\x00\x00\x004@")     # 20.0
lsm_wkb = WKB("\x01"*  # little endian
              "\xd2\x07\x00\x00"*  # type
              "\x02\x00\x00\x00"*  # 2 vertices
              "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
              "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
              "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
              "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
              "ffffff\x14@"*                   # 5.1
              "\x00\x00\x00\x00\x00\x004@")     # 20.0
lszm = (type="LineString", coordinates=[[2.2, -4.4, -10.0, 0.1],
                                        [-3.1, 5.1, 20.0, -0.9]])
lszm_wkb = WKB("\x00"*  # big endian
               "\x00\x00\x0b\xba"*  # type
               "\x00\x00\x00\x02"*  # 2 vertices
               "@\x01\x99\x99\x99\x99\x99\x9a"*     # 2.2
               "\xc0\x11\x99\x99\x99\x99\x99\x9a"*  # -4.4
               "\xc0\$\x00\x00\x00\x00\x00\x00"*     # -10.0
               "?\xb9\x99\x99\x99\x99\x99\x9a"*     # 0.1
               "\xc0\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # -3.1
               "@\x14ffffff"*                       # 5.1
               "@4\x00\x00\x00\x00\x00\x00"*        # 20.0
               "\xbf\xec\xcc\xcc\xcc\xcc\xcc\xcd")  # -0.9
ls2d_srid1234 = (type="LineString",
                 coordinates=[[2.2, 4.4], [3.1, 5.1]],
                 meta=(srid=1234,),
                 crs=(type="name", properties=(name="EPSG1234",)))
ls2d_srid1234_wkb = WKB("\x00"*  # big endian
                        "\x20\x00\x00\x02"*  # type with SRID flag set
                        "\x00\x00\x04\xd2"*  # srid
                        "\x00\x00\x00\x02"*  # 2 vertices
                        "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
                        "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
                        "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
                        "@\x14ffffff")                    # 5.1

# Polygon =====================================================================
pg2d = (type="Polygon", coordinates=[
    [[100.001, 0.001], [101.12345, 0.001], [101.001, 1.001], [100.001, 0.001]],
    [[100.201, 0.201], [100.801, 0.201], [100.801, 0.801], [100.201, 0.201]]
])
pg2d_wkb = WKB( "\x00"*
                "\x00\x00\x00\x03"*  # type
                    # number of rings, 4 byte int
                "\x00\x00\x00\x02"*
                    # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                    # coords
                "@Y\x00\x10bM\xd2\xf2"*     # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                "@YG\xe6\x9a\xd4,="*        # 101.12345
                "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                "@Y@\x10bM\xd2\xf2"*        # 101.001
                "?\xf0\x04\x18\x93t\xbcj"*  # 1.001
                "@Y\x00\x10bM\xd2\xf2"*     # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                    # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                    # coords
                "@Y\x0c\xdd/\x1a\x9f\xbe"*     # 100.201
                "?\xc9\xba^5?|\xee"*           # 0.201
                "@Y3C\x95\x81\x06%"*           # 100.801
                "?\xc9\xba^5?|\xee"*           # 0.201
                "@Y3C\x95\x81\x06%"*           # 100.801
                "?\xe9\xa1\xca\xc0\x83\x12o"*  # 0.801
                "@Y\x0c\xdd/\x1a\x9f\xbe"*     # 100.201
                "?\xc9\xba^5?|\xee") # 0.201
pgz = (type="Polygon", coordinates=[
    [[100.001, 0.001, 0.0], [101.12345, 0.001, 1.0], [101.001, 1.001, 2.0], [100.001, 0.001, 0.0]],
    [[100.201, 0.201, 0.0], [100.801, 0.201, 1.0], [100.801, 0.801, 2.0], [100.201, 0.201, 0.0]]
])
pgz_wkb = WKB(  "\x00"*
                "\x00\x00\x03\xeb"*  # type
                # number of rings, 4 byte int
                "\x00\x00\x00\x02"*
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@YG\xe6\x9a\xd4,="*                 # 101.12345
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y@\x10bM\xd2\xf2"*                 # 101.001
                "?\xf0\x04\x18\x93t\xbcj"*           # 1.001
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xe9\xa1\xca\xc0\x83\x12o"*        # 0.801
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00")  # 0.0
pgm_wkb = WKB(  "\x00"*
                "\x00\x00\x07\xd3"*  # type
                # number of rings, 4 byte int
                "\x00\x00\x00\x02"*
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@YG\xe6\x9a\xd4,="*                 # 101.12345
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y@\x10bM\xd2\xf2"*                 # 101.001
                "?\xf0\x04\x18\x93t\xbcj"*           # 1.001
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xe9\xa1\xca\xc0\x83\x12o"*        # 0.801
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00")  # 0.0
pgzm = (type="Polygon", coordinates=[
    [[100.001, 0.001, 0.0, 0.0], [101.12345, 0.001, 1.0, 1.0], [101.001, 1.001, 2.0, 2.0], [100.001, 0.001, 0.0, 0.0]],
    [[100.201, 0.201, 0.0, 0.0], [100.801, 0.201, 1.0, 0.0], [100.801, 0.801, 2.0, 1.0], [100.201, 0.201, 0.0, 0.0]],
])
pgzm_wkb = WKB( "\x00"*
                "\x00\x00\x0b\xbb"*  # type
                # number of rings, 4 byte int
                "\x00\x00\x00\x02"*
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@YG\xe6\x9a\xd4,="*                 # 101.12345
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y@\x10bM\xd2\xf2"*                 # 101.001
                "?\xf0\x04\x18\x93t\xbcj"*           # 1.001
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "@Y\x00\x10bM\xd2\xf2"*              # 100.001
                "?PbM\xd2\xf1\xa9\xfc"*              # 0.001
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                # number of verts in ring (4)
                "\x00\x00\x00\x04"*
                # coords
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "@Y3C\x95\x81\x06%"*                 # 100.801
                "?\xe9\xa1\xca\xc0\x83\x12o"*        # 0.801
                "@\x00\x00\x00\x00\x00\x00\x00"*     # 2.0
                "?\xf0\x00\x00\x00\x00\x00\x00"*     # 1.0
                "@Y\x0c\xdd/\x1a\x9f\xbe"*           # 100.201
                "?\xc9\xba^5?|\xee"*                 # 0.201
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\x00\x00\x00\x00\x00\x00\x00\x00")  # 0.0
pg2d_srid26918 = (type="Polygon", coordinates=[
        [[100.001, 0.001], [101.12345, 0.001], [101.001, 1.001],
         [100.001, 0.001]],
        [[100.201, 0.201], [100.801, 0.201], [100.801, 0.801],
         [100.201, 0.201]]
    ],
    meta=(srid=26918,),
    crs=(type="name", properties=(name="EPSG26918",)))
pg2d_srid26918_wkb = WKB(   "\x00"*  # big endian
                            "\x20\x00\x00\x03"*  # type, with SRID flag set (0x20)
                            "\x00\x00\x69\x26"*  # 4 bytes containing SRID (SRID=26918)
                            # number of rings, 4 byte int
                            "\x00\x00\x00\x02"*
                            # number of verts in ring (4)
                            "\x00\x00\x00\x04"*
                            # coords
                            "@Y\x00\x10bM\xd2\xf2"*     # 100.001
                            "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                            "@YG\xe6\x9a\xd4,="*        # 101.12345
                            "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                            "@Y@\x10bM\xd2\xf2"*        # 101.001
                            "?\xf0\x04\x18\x93t\xbcj"*  # 1.001
                            "@Y\x00\x10bM\xd2\xf2"*     # 100.001
                            "?PbM\xd2\xf1\xa9\xfc"*     # 0.001
                            # number of verts in ring (4)
                            "\x00\x00\x00\x04"*
                            # coords
                            "@Y\x0c\xdd/\x1a\x9f\xbe"*     # 100.201
                            "?\xc9\xba^5?|\xee"*           # 0.201
                            "@Y3C\x95\x81\x06%"*           # 100.801
                            "?\xc9\xba^5?|\xee"*           # 0.201
                            "@Y3C\x95\x81\x06%"*           # 100.801
                            "?\xe9\xa1\xca\xc0\x83\x12o"*  # 0.801
                            "@Y\x0c\xdd/\x1a\x9f\xbe"*     # 100.201
                            "?\xc9\xba^5?|\xee")           # 0.201

# MultiPoint ==================================================================
mpt2d = (type="MultiPoint", coordinates=[[2.2, 4.4], [10.0, 3.1], [5.1, 20.0]])
        (type = "MultiPoint", coordinates =[(type = "Point", coordinates = [2.2, 4.4]), (type = "Point", coordinates = [10.0, 3.1]), (type
= "Point", coordinates = [5.1, 20.0])]) == (type = "MultiPoint", coordinates = Array{Float64,1}[[2.2, 4.4], [10.0, 3.1], [5.1, 20.0]])
mpt2d_wkb = WKB("\x01"*  # little endian
                "\x04\x00\x00\x00"*
                # number of points: 3
                "\x03\x00\x00\x00"*
                # point 2d
                "\x01"*  # little endian
                "\x01\x00\x00\x00"*
                "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
                "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
                # point 2d
                "\x01"*  # little endian
                "\x01\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
                "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
                # point 2d
                "\x01"*  # little endian
                "\x01\x00\x00\x00"*
                "ffffff\x14@"*                    # 5.1
                "\x00\x00\x00\x00\x00\x004@")     # 20.0
mptz = (type="MultiPoint",
        coordinates=[[2.2, 4.4, 3.0], [10.0, 3.1, 2.0], [5.1, 20.0, 4.4]])
mptz_wkb = WKB( "\x01"*  # little endian
                "\xec\x03\x00\x00"*
                # number of points: 3
                "\x03\x00\x00\x00"*
                # point 3d
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
                "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
                "\x00\x00\x00\x00\x00\x00\x08@"*  # 3.0
                # point 3d
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
                "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
                "\x00\x00\x00\x00\x00\x00\x00@"*  # 2.0
                # point 3d
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "ffffff\x14@"*                    # 5.1
                "\x00\x00\x00\x00\x00\x004@"*     # 20.0
                "\x9a\x99\x99\x99\x99\x99\x11@")  # 4.4
mptm_wkb = WKB( "\x01"*  # little endian
                "\xd4\x07\x00\x00"*
                # number of points: 3
                "\x03\x00\x00\x00"*
                # point m
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
                "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
                "\x00\x00\x00\x00\x00\x00\x08@"*  # 3.0
                # point m
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
                "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
                "\x00\x00\x00\x00\x00\x00\x00@"*  # 2.0
                # point m
                "\x01"*  # little endian
                "\xe9\x03\x00\x00"*
                "ffffff\x14@"*                    # 5.1
                "\x00\x00\x00\x00\x00\x004@"*     # 20.0
                "\x9a\x99\x99\x99\x99\x99\x11@")  # 4.4
mptzm = (type="MultiPoint",
        coordinates=[[2.2, 4.4, 0.0, 3.0], [10.0, 3.1, 0.0, 2.0], [5.1, 20.0, 0.0, 4.4]])
mptzm_wkb = WKB("\x01"*  # little endian
            "\xbc\x0b\x00\x00"*
            # number of points: 3
            "\x03\x00\x00\x00"*
            # point 4d
            "\x01"*  # little endian
            "\xb9\x0b\x00\x00"*
            "\x9a\x99\x99\x99\x99\x99\x01@"*     # 2.2
            "\x9a\x99\x99\x99\x99\x99\x11@"*     # 4.4
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "\x00\x00\x00\x00\x00\x00\x08@"*     # 3.0
            # point 4d
            "\x01"*  # little endian
            "\xb9\x0b\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\$@"*        # 10.0
            "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*     # 3.1
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "\x00\x00\x00\x00\x00\x00\x00@"*     # 2.0
            # point 4d
            "\x01"*  # little endian
            "\xb9\x0b\x00\x00"*
            "ffffff\x14@"*                       # 5.1
            "\x00\x00\x00\x00\x00\x004@"*        # 20.0
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "\x9a\x99\x99\x99\x99\x99\x11@")     # 4.4
mpt2d_srid664 = (type="MultiPoint",
                coordinates=[[2.2, 4.4], [10.0, 3.1], [5.1, 20.0]],
                meta=(srid=664,),
                crs=(type="name", properties=(name="EPSG664",)))
mpt2d_srid664_wkb = WKB(
            "\x01"*  # little endian
            "\x04\x00\x00\x20"*  # type with SRID flag set
            "\x98\x02\x00\x00"*  # SRID 664
            # number of points: 3
            "\x03\x00\x00\x00"*
            # point 2d
            "\x01"*  # little endian
            "\x01\x00\x00\x00"*
            "\x9a\x99\x99\x99\x99\x99\x01@"*  # 2.2
            "\x9a\x99\x99\x99\x99\x99\x11@"*  # 4.4
            # point 2d
            "\x01"*  # little endian
            "\x01\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\$@"*     # 10.0
            "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*  # 3.1
            # point 2d
            "\x01"*  # little endian
            "\x01\x00\x00\x00"*
            "ffffff\x14@"*                    # 5.1
            "\x00\x00\x00\x00\x00\x004@")     # 20.0

# MultiLineString =============================================================
mls2d = (type="MultiLineString",
        coordinates=[[[2.2, 4.4], [3.1, 5.1], [5.1, 20.0]],
                    [[20.0, 2.2], [3.1, 4.4]],])
mls2d_wkb = WKB("\x00"*
                "\x00\x00\x00\x05"*
                "\x00\x00\x00\x02"*  # number of linestrings
                "\x00"*
                "\x00\x00\x00\x02"*
                "\x00\x00\x00\x03"*
                "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
                "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
                "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
                "@\x14ffffff"*                    # 5.1
                "@\x14ffffff"*                    # 5.1
                "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
                "\x00"*
                "\x00\x00\x00\x02"*
                "\x00\x00\x00\x02"*
                "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
                "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
                "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
                "@\x11\x99\x99\x99\x99\x99\x9a")  # 4.4
mlsz = (type="MultiLineString",
        coordinates=[
                    [[2.2, 0.0, 4.4], [3.1, 5.1, 5.1], [5.1, 20.0, 0.0]],
                    [[20.0, 2.2, 2.2], [0.0, 3.1, 4.4]],])
mlsz_wkb = WKB(
            "\x00"*
            "\x00\x00\x03\xed"*
            "\x00\x00\x00\x02"*  # number of linestrings
            "\x00"*
            "\x00\x00\x03\xea"*
            "\x00\x00\x00\x03"*
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
            "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
            "@\x14ffffff"*                    # 5.1
            "@\x14ffffff"*                    # 5.1
            "@\x14ffffff"*                    # 5.1
            "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "\x00"*
            "\x00\x00\x03\xea"*
            "\x00\x00\x00\x02"*
            "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
            "@\x11\x99\x99\x99\x99\x99\x9a")  # 4.4
mlsm_wkb = WKB(
            "\x00"*
            "\x00\x00\x07\xd5"*
            "\x00\x00\x00\x02"*  # number of linestrings
            "\x00"*
            "\x00\x00\x03\xea"*
            "\x00\x00\x00\x03"*
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
            "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
            "@\x14ffffff"*                    # 5.1
            "@\x14ffffff"*                    # 5.1
            "@\x14ffffff"*                    # 5.1
            "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "\x00"*
            "\x00\x00\x03\xea"*
            "\x00\x00\x00\x02"*
            "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
            "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
            "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
            "@\x11\x99\x99\x99\x99\x99\x9a")  # 4.4
mlszm = (type="MultiLineString",
        coordinates=[[[2.2, 4.4, 0.0, 3.0], [10.0, 0.0, 3.1, 2.0]],
                    [[0.0, 5.1, 20.0, 4.4]],])
mlszm_wkb = WKB("\x01"*
                "\xbd\x0b\x00\x00"*
                "\x02\x00\x00\x00"*  # two linestrings
                "\x01"*
                "\xba\x0b\x00\x00"*
                "\x02\x00\x00\x00"*  # two points
                "\x9a\x99\x99\x99\x99\x99\x01@"*     # 2.2
                "\x9a\x99\x99\x99\x99\x99\x11@"*     # 4.4
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\x00\x00\x00\x00\x00\x00\x08@"*     # 3.0
                "\x00\x00\x00\x00\x00\x00\$@"*        # 10.0
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "\xcd\xcc\xcc\xcc\xcc\xcc\x08@"*     # 3.1
                "\x00\x00\x00\x00\x00\x00\x00@"*     # 2.0
                "\x01"*
                "\xba\x0b\x00\x00"*
                "\x01\x00\x00\x00"*  # one point
                "\x00\x00\x00\x00\x00\x00\x00\x00"*  # 0.0
                "ffffff\x14@"*                       # 5.1
                "\x00\x00\x00\x00\x00\x004@"*        # 20.0
                "\x9a\x99\x99\x99\x99\x99\x11@")     # 4.4
mls2d_srid4326 = (  type="MultiLineString",
                    coordinates=[[[2.2, 4.4], [3.1, 5.1], [5.1, 20.0]],
                                 [[20.0, 2.2], [3.1, 4.4]]],
                    meta=(srid=4326,),
                    crs=(type="name", properties=(name="EPSG4326",)))
mls2d_srid4326_wkb = WKB("\x00"*
                        "\x20\x00\x00\x05"*  # type with SRID flag set
                        "\x00\x00\x10\xe6"*  # SRID 4326
                        "\x00\x00\x00\x02"*  # number of linestrings
                        "\x00"*
                        "\x00\x00\x00\x02"*
                        "\x00\x00\x00\x03"*
                        "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
                        "@\x11\x99\x99\x99\x99\x99\x9a"*  # 4.4
                        "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
                        "@\x14ffffff"*                    # 5.1
                        "@\x14ffffff"*                    # 5.1
                        "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
                        "\x00"*
                        "\x00\x00\x00\x02"*
                        "\x00\x00\x00\x02"*
                        "@4\x00\x00\x00\x00\x00\x00"*     # 20.0
                        "@\x01\x99\x99\x99\x99\x99\x9a"*  # 2.2
                        "@\x08\xcc\xcc\xcc\xcc\xcc\xcd"*  # 3.1
                        "@\x11\x99\x99\x99\x99\x99\x9a")  # 4.4

# MultiPolygon ================================================================
mpg2d = (type="MultiPolygon",
        coordinates=[
            [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0],
              [102.0, 2.0]]],
            [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0],
              [100.0, 0.0]],
             [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8],
              [100.2, 0.2]]],
        ])
mpg2d_wkb = WKB("\x01"*  # little endian
            "\x06\x00\x00\x00"*  # 2d multipolygon
            "\x02\x00\x00\x00"*  # two polygons
            "\x01"*  # little endian
            "\x03\x00\x00\x00"*  # 2d polygon
            "\x01\x00\x00\x00"*  # 1 ring
            "\x05\x00\x00\x00"*  # 5 vertices
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x01"*  # little endian
            "\x03\x00\x00\x00"*  # 2d polygon
            "\x02\x00\x00\x00"*  # 2 rings
            "\x05\x00\x00\x00"*  # first ring, 5 vertices
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x05\x00\x00\x00"*  # second ring, 5 vertices
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?")
mpgz = (type="MultiPolygon", coordinates=[
    [[[102.0, 2.0, 0.0], [103.0, 2.0, 1.0], [103.0, 3.0, 2.0], [102.0, 3.0, 3.0], [102.0, 2.0, 4.0]]],
    [[[100.0, 0.0, 5.0], [101.0, 0.0, 6.0], [101.0, 1.0, 7.0], [100.0, 1.0, 8.0], [100.0, 0.0, 9.0]],
     [[100.2, 0.2, 10.0], [100.8, 0.2, 11.0], [100.8, 0.8, 12.0], [100.2, 0.8, 13.0], [100.2, 0.2, 14.0]]],
])
mpgz_wkb = WKB(
            "\x01"*  # little endian
            "\xee\x03\x00\x00"*  # 3d multipolygon
            "\x02\x00\x00\x00"*  # two polygons
            "\x01"*  # little endian
            "\xeb\x03\x00\x00"*  # 3d polygon
            "\x01\x00\x00\x00"*  # 1 ring
            "\x05\x00\x00\x00"*  # 5 vertices
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\x10@"*
            "\x01"*  # little endian
            "\xeb\x03\x00\x00"*  # 3d polygon
            "\x02\x00\x00\x00"*  # 2 rings
            "\x05\x00\x00\x00"*  # first ring, 5 vertices
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\x14@"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\x18@"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00\x1c@"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00 @"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\"@"*
            "\x05\x00\x00\x00"*  # second ring, 5 vertices
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00\$@"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00&@"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\x00\x00\x00\x00\x00\x00(@"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\x00\x00\x00\x00\x00\x00*@"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00,@")
mpgm_wkb = WKB(
            "\x01"*  # little endian
            "\xd6\x07\x00\x00"*  # m multipolygon
            "\x02\x00\x00\x00"*  # two polygons
            "\x01"*  # little endian
            "\xeb\x03\x00\x00"*  # m polygon
            "\x01\x00\x00\x00"*  # 1 ring
            "\x05\x00\x00\x00"*  # 5 vertices
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\x10@"*
            "\x01"*  # little endian
            "\xeb\x03\x00\x00"*  # m polygon
            "\x02\x00\x00\x00"*  # 2 rings
            "\x05\x00\x00\x00"*  # first ring, 5 vertices
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\x14@"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\x18@"*
            "\x00\x00\x00\x00\x00@Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00\x1c@"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00 @"*
            "\x00\x00\x00\x00\x00\x00Y@"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\"@"*
            "\x05\x00\x00\x00"*  # second ring, 5 vertices
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00\$@"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00&@"*
            "333333Y@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\x00\x00\x00\x00\x00\x00(@"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xe9?"*
            "\x00\x00\x00\x00\x00\x00*@"*
            "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
            "\x9a\x99\x99\x99\x99\x99\xc9?"*
            "\x00\x00\x00\x00\x00\x00,@")
mpgzm = (type="MultiPolygon",
        coordinates=[
            [[[102.0, 2.0, 0.0, 14.0], [103.0, 2.0, 1.0, 13.0],
              [103.0, 3.0, 2.0, 12.0], [102.0, 3.0, 3.0, 11.0],
              [102.0, 2.0, 4.0, 10.0]]],
            [[[100.0, 0.0, 5.0, 9.0], [101.0, 0.0, 6.0, 8.0],
              [101.0, 1.0, 7.0, 7.0], [100.0, 1.0, 8.0, 6.0],
              [100.0, 0.0, 9.0, 5.0]],
             [[100.2, 0.2, 10.0, 4.0], [100.8, 0.2, 11.0, 3.0],
              [100.8, 0.8, 12.0, 2.0], [100.2, 0.8, 13.0, 1.0],
              [100.2, 0.2, 14.0, 0.0]]],
        ])
mpgzm_wkb = WKB("\x01"*  # little endian
                "\xbe\x0b\x00\x00"*  # 4d multipolygon
                "\x02\x00\x00\x00"*  # two polygons
                "\x01"*  # little endian
                "\xbb\x0b\x00\x00"*  # 4d polygon
                "\x01\x00\x00\x00"*  # 1 ring
                "\x05\x00\x00\x00"*  # 5 vertices
                "\x00\x00\x00\x00\x00\x80Y@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00,@"*
                "\x00\x00\x00\x00\x00\xc0Y@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x00\x00\x00\x00\x00\x00\xf0?"*
                "\x00\x00\x00\x00\x00\x00*@"*
                "\x00\x00\x00\x00\x00\xc0Y@"*
                "\x00\x00\x00\x00\x00\x00\x08@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x00\x00\x00\x00\x00\x00(@"*
                "\x00\x00\x00\x00\x00\x80Y@"*
                "\x00\x00\x00\x00\x00\x00\x08@"*
                "\x00\x00\x00\x00\x00\x00\x08@"*
                "\x00\x00\x00\x00\x00\x00&@"*
                "\x00\x00\x00\x00\x00\x80Y@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x00\x00\x00\x00\x00\x00\x10@"*
                "\x00\x00\x00\x00\x00\x00\$@"*
                "\x01"*  # little endian
                "\xbb\x0b\x00\x00"*  # 4d polygon
                "\x02\x00\x00\x00"*  # 2 rings
                "\x05\x00\x00\x00"*  # first ring, 5 vertices
                "\x00\x00\x00\x00\x00\x00Y@"*
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\x14@"*
                "\x00\x00\x00\x00\x00\x00\"@"*
                "\x00\x00\x00\x00\x00@Y@"*
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\x18@"*
                "\x00\x00\x00\x00\x00\x00 @"*
                "\x00\x00\x00\x00\x00@Y@"*
                "\x00\x00\x00\x00\x00\x00\xf0?"*
                "\x00\x00\x00\x00\x00\x00\x1c@"*
                "\x00\x00\x00\x00\x00\x00\x1c@"*
                "\x00\x00\x00\x00\x00\x00Y@"*
                "\x00\x00\x00\x00\x00\x00\xf0?"*
                "\x00\x00\x00\x00\x00\x00 @"*
                "\x00\x00\x00\x00\x00\x00\x18@"*
                "\x00\x00\x00\x00\x00\x00Y@"*
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\"@"*
                "\x00\x00\x00\x00\x00\x00\x14@"*
                "\x05\x00\x00\x00"*  # second ring, 5 vertices
                "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                "\x9a\x99\x99\x99\x99\x99\xc9?"*
                "\x00\x00\x00\x00\x00\x00\$@"*
                "\x00\x00\x00\x00\x00\x00\x10@"*
                "333333Y@"*
                "\x9a\x99\x99\x99\x99\x99\xc9?"*
                "\x00\x00\x00\x00\x00\x00&@"*
                "\x00\x00\x00\x00\x00\x00\x08@"*
                "333333Y@"*
                "\x9a\x99\x99\x99\x99\x99\xe9?"*
                "\x00\x00\x00\x00\x00\x00(@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                "\x9a\x99\x99\x99\x99\x99\xe9?"*
                "\x00\x00\x00\x00\x00\x00*@"*
                "\x00\x00\x00\x00\x00\x00\xf0?"*
                "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                "\x9a\x99\x99\x99\x99\x99\xc9?"*
                "\x00\x00\x00\x00\x00\x00,@"*
                "\x00\x00\x00\x00\x00\x00\x00\x00")
mpg2d_srid4326 = (
    type="MultiPolygon",
    coordinates=[
        [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0],
          [102.0, 2.0]]],
        [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0],
          [100.0, 0.0]],
         [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8],
          [100.2, 0.2]]],
    ],
    meta=(srid=4326,),
    crs=(type="name", properties=(name="EPSG4326",)),
)
mpg2d_srid4326_wkb = WKB("\x01"*  # little endian
                        "\x06\x00\x00\x20"*  # 2d multipolygon wth SRID flag
                        "\xe6\x10\x00\x00"*  # 4 bytes containing SRID (SRID=4326)
                        "\x02\x00\x00\x00"*  # two polygons
                        "\x01"*  # little endian
                        "\x03\x00\x00\x00"*  # 2d polygon
                        "\x01\x00\x00\x00"*  # 1 ring
                        "\x05\x00\x00\x00"*  # 5 vertices
                        "\x00\x00\x00\x00\x00\x80Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00@"*
                        "\x00\x00\x00\x00\x00\xc0Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00@"*
                        "\x00\x00\x00\x00\x00\xc0Y@"*
                        "\x00\x00\x00\x00\x00\x00\x08@"*
                        "\x00\x00\x00\x00\x00\x80Y@"*
                        "\x00\x00\x00\x00\x00\x00\x08@"*
                        "\x00\x00\x00\x00\x00\x80Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00@"*
                        "\x01"*  # little endian
                        "\x03\x00\x00\x00"*  # 2d polygon
                        "\x02\x00\x00\x00"*  # 2 rings
                        "\x05\x00\x00\x00"*  # first ring, 5 vertices
                        "\x00\x00\x00\x00\x00\x00Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00\x00"*
                        "\x00\x00\x00\x00\x00@Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00\x00"*
                        "\x00\x00\x00\x00\x00@Y@"*
                        "\x00\x00\x00\x00\x00\x00\xf0?"*
                        "\x00\x00\x00\x00\x00\x00Y@"*
                        "\x00\x00\x00\x00\x00\x00\xf0?"*
                        "\x00\x00\x00\x00\x00\x00Y@"*
                        "\x00\x00\x00\x00\x00\x00\x00\x00"*
                        "\x05\x00\x00\x00"*  # second ring, 5 vertices
                        "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                        "\x9a\x99\x99\x99\x99\x99\xc9?"*
                        "333333Y@"*
                        "\x9a\x99\x99\x99\x99\x99\xc9?"*
                        "333333Y@"*
                        "\x9a\x99\x99\x99\x99\x99\xe9?"*
                        "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                        "\x9a\x99\x99\x99\x99\x99\xe9?"*
                        "\xcd\xcc\xcc\xcc\xcc\x0cY@"*
                        "\x9a\x99\x99\x99\x99\x99\xc9?")

# GeometryCollection ==========================================================
gc2d = (type="GeometryCollection",
        geometries=[
            (type="Point", coordinates=[0.0, 1.0]),
            (type="LineString", coordinates=[
                [102.0, 2.0], [103.0, 3.0], [104.0, 4.0]
            ]),
        ])
gc2d_wkb = WKB( "\x00"*  # big endian
                "\x00\x00\x00\x07"*  # 2d geometry collection
                "\x00\x00\x00\x02"*  # 2 geometries in the collection
                "\x00"*
                "\x00\x00\x00\x01"*  # 2d point
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "?\xf0\x00\x00\x00\x00\x00\x00"*
                "\x00"*
                "\x00\x00\x00\x02"*  # 2d linestring
                "\x00\x00\x00\x03"*  # 3 vertices
                "@Y\x80\x00\x00\x00\x00\x00"*
                "@\x00\x00\x00\x00\x00\x00\x00"*
                "@Y\xc0\x00\x00\x00\x00\x00"*
                "@\x08\x00\x00\x00\x00\x00\x00"*
                "@Z\x00\x00\x00\x00\x00\x00"*
                "@\x10\x00\x00\x00\x00\x00\x00")
gcz = (type="GeometryCollection",
        geometries=[
            (type="Point", coordinates=[0.0, 1.0, 2.0]),
            (type="LineString", coordinates=[
                [102.0, 2.0, 6.0], [103.0, 3.0, 7.0], [104.0, 4.0, 8.0]
            ]),
        ])
gcz_wkb = WKB( "\x01"*  # little endian
                "\xef\x03\x00\x00"*  # 3d geometry collection
                "\x02\x00\x00\x00"*  # 2 geometries in the collection
                "\x01"*
                "\xe9\x03\x00\x00"*  # 3d point
                "\x00\x00\x00\x00\x00\x00\x00\x00"*
                "\x00\x00\x00\x00\x00\x00\xf0?"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x01"*
                "\xea\x03\x00\x00"*  # 3d linestring
                "\x03\x00\x00\x00"*  # 3 vertices
                "\x00\x00\x00\x00\x00\x80Y@"*
                "\x00\x00\x00\x00\x00\x00\x00@"*
                "\x00\x00\x00\x00\x00\x00\x18@"*
                "\x00\x00\x00\x00\x00\xc0Y@"*
                "\x00\x00\x00\x00\x00\x00\x08@"*
                "\x00\x00\x00\x00\x00\x00\x1c@"*
                "\x00\x00\x00\x00\x00\x00Z@"*
                "\x00\x00\x00\x00\x00\x00\x10@"*
                "\x00\x00\x00\x00\x00\x00 @")
gcm_wkb = WKB(
            "\x01"*  # little endian
            "\xd7\x07\x00\x00"*
            "\x02\x00\x00\x00"*  # 2 geometries in the collection
            "\x01"*
            "\xd1\x07\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "\x00\x00\x00\x00\x00\x00\xf0?"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x01"*
            "\xd2\x07\x00\x00"*
            "\x03\x00\x00\x00"*  # 3 vertices
            "\x00\x00\x00\x00\x00\x80Y@"*
            "\x00\x00\x00\x00\x00\x00\x00@"*
            "\x00\x00\x00\x00\x00\x00\x18@"*
            "\x00\x00\x00\x00\x00\xc0Y@"*
            "\x00\x00\x00\x00\x00\x00\x08@"*
            "\x00\x00\x00\x00\x00\x00\x1c@"*
            "\x00\x00\x00\x00\x00\x00Z@"*
            "\x00\x00\x00\x00\x00\x00\x10@"*
            "\x00\x00\x00\x00\x00\x00 @")
gczm = (type="GeometryCollection", geometries=[
            (type="Point", coordinates=[0.0, 1.0, 2.0, 3.0]),
            (type="LineString", coordinates=[
                [102.0, 2.0, 6.0, 10.0], [103.0, 3.0, 7.0, 11.0],
                [104.0, 4.0, 8.0, 12.0]
            ]),
        ])
gczm_wkb = WKB(
            "\x00"*  # big endian
            "\x00\x00\x0b\xbf"*  # 4d geometry collection
            "\x00\x00\x00\x02"*  # 2 geometries in the collection
            "\x00"*
            "\x00\x00\x0b\xb9"*  # 4d point
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "?\xf0\x00\x00\x00\x00\x00\x00"*
            "@\x00\x00\x00\x00\x00\x00\x00"*
            "@\x08\x00\x00\x00\x00\x00\x00"*
            "\x00"*
            "\x00\x00\x0b\xba"*  # 4d linestring
            "\x00\x00\x00\x03"*  # 3 vertices
            "@Y\x80\x00\x00\x00\x00\x00"*
            "@\x00\x00\x00\x00\x00\x00\x00"*
            "@\x18\x00\x00\x00\x00\x00\x00"*
            "@\$\x00\x00\x00\x00\x00\x00"*
            "@Y\xc0\x00\x00\x00\x00\x00"*
            "@\x08\x00\x00\x00\x00\x00\x00"*
            "@\x1c\x00\x00\x00\x00\x00\x00"*
            "@&\x00\x00\x00\x00\x00\x00"*
            "@Z\x00\x00\x00\x00\x00\x00"*
            "@\x10\x00\x00\x00\x00\x00\x00"*
            "@ \x00\x00\x00\x00\x00\x00"*
            "@(\x00\x00\x00\x00\x00\x00")
gc2d_srid1234 = (type="GeometryCollection",
                geometries=[
                    (type="Point", coordinates=[0.0, 1.0]),
                    (type="LineString", coordinates=[
                        [102.0, 2.0], [103.0, 3.0], [104.0, 4.0]
                    ]),
                ],
                meta=(srid=1234,),
                crs=(type="name", properties=(name="EPSG1234",)))
gc2d_srid1234_wkb = WKB(
            "\x00"*  # big endian
            "\x20\x00\x00\x07"*  # 2d geometry collection
            "\x00\x00\x04\xd2"*  # srid 1234
            "\x00\x00\x00\x02"*  # 2 geometries in the collection
            "\x00"*  # big endian
            "\x00\x00\x00\x01"*  # 2d point
            "\x00\x00\x00\x00\x00\x00\x00\x00"*
            "?\xf0\x00\x00\x00\x00\x00\x00"*
            "\x00"*  # big endian
            "\x00\x00\x00\x02"*  # 2d linestring
            "\x00\x00\x00\x03"*  # 3 vertices
            "@Y\x80\x00\x00\x00\x00\x00"*
            "@\x00\x00\x00\x00\x00\x00\x00"*
            "@Y\xc0\x00\x00\x00\x00\x00"*
            "@\x08\x00\x00\x00\x00\x00\x00"*
            "@Z\x00\x00\x00\x00\x00\x00"*
            "@\x10\x00\x00\x00\x00\x00\x00")
