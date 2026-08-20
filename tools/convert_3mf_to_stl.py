#!/usr/bin/env python3
"""Convert direct mesh objects in a 3MF archive to one ASCII STL.

This intentionally supports the simple no-transform mesh structure used by the
supplied NexGen button emblem. It rejects component graphs and item transforms
instead of silently producing misplaced geometry.
"""

import math
import sys
import xml.etree.ElementTree as ET
import zipfile


def normal(a, b, c):
    ab = tuple(b[i] - a[i] for i in range(3))
    ac = tuple(c[i] - a[i] for i in range(3))
    cross = (
        ab[1] * ac[2] - ab[2] * ac[1],
        ab[2] * ac[0] - ab[0] * ac[2],
        ab[0] * ac[1] - ab[1] * ac[0],
    )
    length = math.sqrt(sum(value * value for value in cross))
    if length == 0:
        return (0.0, 0.0, 0.0)
    return tuple(value / length for value in cross)


def main(source, destination):
    meshes = []
    with zipfile.ZipFile(source) as archive:
        model_names = [name for name in archive.namelist() if name.endswith(".model")]
        if len(model_names) != 1:
            raise ValueError(f"expected one .model file, found {len(model_names)}")
        root = ET.fromstring(archive.read(model_names[0]))
        if root.findall(".//{*}component"):
            raise ValueError("component graphs are not supported")
        for item in root.findall(".//{*}build/{*}item"):
            if "transform" in item.attrib:
                raise ValueError("build transforms are not supported")
        for mesh in root.findall(".//{*}object/{*}mesh"):
            vertices = [
                tuple(float(vertex.attrib[axis]) for axis in ("x", "y", "z"))
                for vertex in mesh.findall("./{*}vertices/{*}vertex")
            ]
            triangles = [
                tuple(int(triangle.attrib[index]) for index in ("v1", "v2", "v3"))
                for triangle in mesh.findall("./{*}triangles/{*}triangle")
            ]
            meshes.append((vertices, triangles))

    with open(destination, "w", encoding="ascii", newline="\n") as output:
        output.write("solid converted_3mf\n")
        for vertices, triangles in meshes:
            for indices in triangles:
                points = [vertices[index] for index in indices]
                nx, ny, nz = normal(*points)
                output.write(f"  facet normal {nx:.9g} {ny:.9g} {nz:.9g}\n")
                output.write("    outer loop\n")
                for x, y, z in points:
                    output.write(f"      vertex {x:.9g} {y:.9g} {z:.9g}\n")
                output.write("    endloop\n")
                output.write("  endfacet\n")
        output.write("endsolid converted_3mf\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(f"usage: {sys.argv[0]} SOURCE.3mf DESTINATION.stl")
    main(sys.argv[1], sys.argv[2])
