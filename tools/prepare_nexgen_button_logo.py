#!/usr/bin/env python3
"""Reorient the supplied NexGen multi-material button logo without remeshing.

The source keeps three colour objects. Vertices are transformed from the source
print orientation (thickness along X) to a local cap orientation (thickness
along Z), centred at X/Y with the rear face at Z=0.
"""

import copy
import sys
import xml.etree.ElementTree as ET
import zipfile


SOURCE_CENTER_Y = 4.527873
SOURCE_CENTER_Z = 95.01802
SOURCE_MAX_X = 3.566254


def main(source, destination):
    with zipfile.ZipFile(source) as input_archive:
        model_names = [name for name in input_archive.namelist() if name.endswith(".model")]
        if len(model_names) != 1:
            raise ValueError(f"expected one model, found {len(model_names)}")
        model_name = model_names[0]
        root = ET.fromstring(input_archive.read(model_name))

        for vertex in root.findall(".//{*}vertex"):
            old_x = float(vertex.attrib["x"])
            old_y = float(vertex.attrib["y"])
            old_z = float(vertex.attrib["z"])
            vertex.attrib["x"] = f"{old_z - SOURCE_CENTER_Z:.6f}"
            vertex.attrib["y"] = f"{old_y - SOURCE_CENTER_Y:.6f}"
            vertex.attrib["z"] = f"{SOURCE_MAX_X - old_x:.6f}"

        transformed_model = ET.tostring(root, encoding="utf-8", xml_declaration=True)
        with zipfile.ZipFile(destination, "w", compression=zipfile.ZIP_DEFLATED) as output_archive:
            for item in input_archive.infolist():
                data = transformed_model if item.filename == model_name else input_archive.read(item.filename)
                output_archive.writestr(copy.copy(item), data)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(f"usage: {sys.argv[0]} SOURCE.3mf DESTINATION.3mf")
    main(sys.argv[1], sys.argv[2])
