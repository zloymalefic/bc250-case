#!/usr/bin/env python3
"""Print raw vertex bounds for one or more 3MF archives."""

import sys
import xml.etree.ElementTree as ET
import zipfile


for path in sys.argv[1:]:
    points = []
    with zipfile.ZipFile(path) as archive:
        for name in archive.namelist():
            if not name.endswith(".model"):
                continue
            root = ET.fromstring(archive.read(name))
            for vertex in root.findall(".//{*}vertex"):
                points.append(
                    tuple(float(vertex.attrib[axis]) for axis in ("x", "y", "z"))
                )

    if not points:
        print(f"{path}: no vertices")
        continue

    minimum = [min(point[index] for point in points) for index in range(3)]
    maximum = [max(point[index] for point in points) for index in range(3)]
    size = [maximum[index] - minimum[index] for index in range(3)]
    dimensions = " x ".join(f"{value:.2f}" for value in size)
    print(f"{path}: raw bounds {dimensions} mm ({len(points)} vertices)")
